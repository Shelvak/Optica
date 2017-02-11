class Historial < ActiveRecord::Base

  belongs_to :cliente
  has_many :recetes
  accepts_nested_attributes_for :recetes, allow_destroy: true

  attr_accessor :auto_cliente

  before_validation :asignar_cliente
  after_save :asignar_total, :asignar_lente
  before_save :eliminar_vacio, :asignar_retirado

  scope :asociado, lambda { |cliente| where('cliente_id LIKE ?', "#{cliente}") }
  scope :contactos, -> { where(tipolente: true) }
  scope :flotantes, -> { where(tipolente: false) }
  scope :asociado, lambda { |cliente| where('cliente_id LIKE ?', "#{cliente}") }

  validates :auto_cliente, presence: true
  validates :entrega, presence: true
  validates :precio, numericality: true
  validates :orden, numericality: {
      only_integer: true, greater_than_or_equal_to: 0,
          less_than: 2147483648 }, allow_nil: true, allow_blank: true


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


   def self.search(search)
    if search.present?
      includes(:cliente).where(
        [
          "LOWER(#{Cliente.table_name}.nombre) LIKE :q",
          "LOWER(#{Cliente.table_name}.apellido) LIKE :q",
          "#{Cliente.table_name}.documento LIKE :q",
          "#{table_name}.factura LIKE :q",
          "#{table_name}.orden LIKE :q"
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

  def asignar_cliente
    if self.auto_cliente.present?
      self.cliente = Cliente.find_by_documento(self.auto_cliente.split(' ').last)
    end
  end

  def flotante?
    !self.tipolente?
  end

  def contacto?
    self.tipolente?
  end

  def asignar_total
    #if self.created_at == self.updated_at && self.entrega > Date.today
      #cliente = self.cliente
      #venta = Venta.find_or_create_by_mes_and_anio(Date.today.month, Date.today.year)
      #venta.vendido += self.precio
      #venta.cantvendida += 1
      #if self.tipolente == false
      #  venta.cant_flotante += 1
      #  venta.venta_flotante += self.precio
      #elsif self.tipolente == true
      #  venta.cant_contacto += 1
      #  venta.venta_contacto += self.precio
      #end
      #venta.save
    self.cliente.gastado += self.precio
    self.cliente.save
    #end
  end

  def asignar_lente
    @historial = Historial.order('created_at DESC').first
    @cliente = Cliente.find(@historial.try(:cliente_id))
    if @cliente.lente == nil
      @cliente.lente = 'flotantes' if (@historial.tipolente == false)
      @cliente.lente = 'contacto' if (@historial.tipolente == true)
    end

    (@cliente.lente = 'ambos' if (@historial.tipolente == false)) if @cliente.lente == 'contacto'
    (@cliente.lente = 'ambos' if (@historial.tipolente == true)) if @cliente.lente == 'flotantes'
    @cliente.update_attributes(lente: @cliente.lente)

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

end
