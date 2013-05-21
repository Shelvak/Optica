class Historial < ActiveRecord::Base
  
  belongs_to :cliente
  has_many :recetes
  accepts_nested_attributes_for :recetes, :allow_destroy => true
  
  attr_accessor :auto_cliente
  
  before_validation :asignar_cliente
  after_save :asignar_total, :asignar_lente
  before_save :eliminar_vacio, :asignar_retirado
  
  scope :asociado, lambda { |cliente| where('cliente_id LIKE ?', "#{cliente}") }
  
  validates :auto_cliente, presence: true
  validates :precio, numericality: true
  validates :orden, numericality: {
      only_integer: true, greater_than_or_equal_to: 0,
          less_than: 2147483648 }, allow_nil: true, allow_blank: true
  
  
  def initialize(attributes = nil, options = {}) 
    super(attributes, options)
    
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
          "LOWER(#{Cliente.table_name}.documento) LIKE :q",
          "LOWER(#{table_name}.factura) LIKE :q",
          "LOWER(#{table_name}.orden) LIKE :q"
        ].join(' OR '),
        q: "#{search}%".downcase
      )
    else
      scoped
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
  
  def asignar_total
    @historial = Historial.order('created_at DESC').first
    if @historial.created_at == @historial.updated_at && @historial.entrega > Date.today
      @cliente = Cliente.find_by_documento(@historial.cliente.documento)
      @venta = Venta.find_or_create_by_mes_and_anio(Date.today.month, Date.today.year)
      @venta.vendido += @historial.precio
      @venta.cantvendida += 1
        if @historial.tipolente == false
          @venta.cant_flotante += 1
          @venta.venta_flotante += @historial.precio
          @venta.update_attributes(venta_flotante: @venta.venta_flotante, cant_flotante: @venta.cant_flotante)
        elsif @historial.tipolente == true
          @venta.cant_contacto += 1
          @venta.venta_contacto += @historial.precio
          @venta.update_attributes(venta_contacto: @venta.venta_contacto, cant_contacto: @venta.cant_contacto)
        end  
      @cliente.gastado += @historial.precio
      @venta.update_attributes(vendido: @venta.vendido, cantvendida: @venta.cantvendida)
      @cliente.update_attributes(gastado: @cliente.gastado)
    end
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
