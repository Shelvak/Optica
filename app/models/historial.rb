class Historial < ActiveRecord::Base
  
  belongs_to :cliente
  has_many :recetes
  accepts_nested_attributes_for :recetes
  attr_accessor :auto_cliente
  before_validation :asignar_cliente
  after_save :asignar_total, :asignar_lente
  
  scope :asociado, lambda { |cliente| where('cliente_id LIKE ?', "#{cliente}") }
  
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
  
  def asignar_cliente
    if self.auto_cliente.present?
      self.cliente = Cliente.find_by_documento(self.auto_cliente.split(' ').last)
    end
  end
  
  def asignar_total
    @venta = Venta.find_or_create_by_mes_and_anio(Date.today.month, Date.today.year)
    @historial = Historial.order('created_at DESC').first
    @cliente = Cliente.find_by_documento(@historial.cliente.documento)
    @venta.vendido += @historial.precio
    @venta.cantvendida += 1
    @cliente.gastado += @historial.precio
    @venta.update_attributes(vendido: @venta.vendido, cantvendida: @venta.cantvendida)
    @cliente.update_attributes(gastado: @cliente.gastado)
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
  
end
