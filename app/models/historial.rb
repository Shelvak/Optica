class Historial < ActiveRecord::Base
  
  belongs_to :cliente
  has_many :recetes
  accepts_nested_attributes_for :recetes, :allow_destroy => true
  
  attr_accessor :auto_cliente
  
  before_validation :asignar_cliente
  after_save :asignar_total, :asignar_lente
  #  , :asignar_adic
  before_save :eliminar_vacio
  
  scope :asociado, lambda { |cliente| where('cliente_id LIKE ?', "#{cliente}") }
  
  validates :auto_cliente, presence: true
  validates :entrega, on: :create, timeliness: { type: :date, on_or_after: :today }
  validates :precio, :orden, :factura, numericality: true
  
  
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
     if search
      where('orden LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  
  def asignar_cliente
    if self.auto_cliente.present?
      self.cliente = Cliente.find_by_documento(self.auto_cliente.split(' ').last)
    end
  end
  
  def asignar_total
    @historial = Historial.order('created_at DESC').first
    if @historial.created_at == @historial.updated_at
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
    @cliente = Cliente.find_by_id(@historial.cliente.id)
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
  
#  def asignar_adic
#    self.a
#  end
  
end
