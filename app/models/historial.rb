class Historial < ActiveRecord::Base
  has_paper_trail
  belongs_to :cliente
  has_many :recetes
  has_many :bills
  has_one :bill
  accepts_nested_attributes_for :recetes, allow_destroy: true

  has_many :attachments, as: :attachable

  attr_accessor :auto_cliente, :files

  # before_validation :asignar_cliente
  after_save :asignar_lente
  after_commit :assign_to_global_sales, on: :create
  before_save :eliminar_vacio, :asignar_retirado

  scope :contactos, -> { where(tipolente: true) }
  scope :flotantes, -> { where(tipolente: false) }
  scope :asociado, lambda { |cliente| where('cliente_id LIKE ?', "#{cliente}") }

  validates :cliente, presence: true
  validates :entrega, presence: true
  validates :precio, numericality: true
  validates :orden, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than: 2147483648
  }, allow_nil: true, allow_blank: true


  def initialize(attributes = {})
    super(attributes)

    if self.recetes.empty?
      [true, false].each do |recete|
        [true, false].each do |ojo|
          self.recetes.build(ojo: ojo, receta: recete)
        end
      end
    end
  end

  def files=(*args)
    (args || []).flatten.compact.map do |file|
      (attachments.create(file: file) rescue nil)
    end
  end


   def self.search(search)
    if search.present?
      joins(:cliente).where(
        [
          "LOWER(#{Cliente.table_name}.nombre) LIKE :q",
          "LOWER(#{Cliente.table_name}.apellido) LIKE :q",
          "#{Cliente.table_name}.documento LIKE :q",
          "#{table_name}.factura LIKE :q",
          "#{table_name}.orden::TEXT LIKE :q"
        ].join(' OR '),
        q: "#{search}%".downcase
      )
    else
      all
    end

  end

   def asignar_retirado
     self.retirado = true if self.entrega < Date.today
   end

  # def asignar_cliente
  #   if self.auto_cliente.present?
  #     self.cliente = Cliente.find_by_documento(self.auto_cliente.split(' ').last)
  #   end
  # end

  def flotante?
    !self.tipolente?
  end

  def contacto?
    self.tipolente?
  end

  def sell_type
    self.contacto? ? :contact : :floating
  end

  def assign_to_global_sales
    if self.factura.present?
      venta = Venta.find_or_initialize_by(
        month: created_at.month, year: created_at.year
      )
      venta.increase_by_type(sell_type, self.precio)
      venta.save
    end

    return unless self.cliente

    self.cliente.gastado += self.precio
    self.cliente.save
  end

  def asignar_lente
    return if self.cliente.blank? || self.cliente.try(:lente) == 'ambos'

    tipo = self.tipolente? ? 'contacto' : 'flotantes'
    cliente.lente = tipo if cliente.lente.blank?
    cliente.lente = 'ambos' if cliente.lente != tipo
    cliente.save
  end


  def to_s
    self.id
  end

  def eliminar_vacio
    if self.tipolente == 0 || self.tipolente == false
      self.recetes[2].destroy if self.recetes[2]
      self.recetes[3].destroy if self.recetes[3]
    end
  end

  def build_bill
    bill = self.bills.new(client_id: self.cliente_id).build_from_historial
  end

  def description
    if flotante?
      "Lente flotante - #{self.armazon}"
    else
      "Lente de contacto - #{self.lente}"
    end
  end
end
