class Cliente < ActiveRecord::Base
 
  
  before_save :camel, :asignar_cantidadrecom
  before_validation :asignar_recomendado, :verificar_documento
  has_many :historials
  #has_many :receta
  
  
  attr_accessor :auto_recomendado
  
  
  scope :buscar, lambda { |nombre| where('LOWER(nombre)LIKE ? OR LOWER(apellido) LIKE ? OR documento LIKE ?',
      "#{nombre}%".downcase, "#{nombre}%".downcase, "#{nombre}%")}

  
  validates :nombre, :apellido, :documento, presence: true
  validates :documento, uniqueness: true, presence: true
  
  def camel
    self.nombre = self.nombre.split.map(&:camelize).join(' ')
    self.apellido = self.apellido.split.map(&:camelize).join(' ')
  end
  
  def to_s 
		self.nombre + ' ' + self.apellido + ' ' + self.documento
	end
  
  def verificar_documento
    self.documento = self.documento.split('.').join
  end
  
  def asignar_recomendado
    if self.auto_recomendado.present?
      self.recomendado = self.auto_recomendado
    end
  end
  
  def asignar_cantidadrecom
    if self.auto_recomendado.present?
      @cliente = Cliente.find_by_documento(self.auto_recomendado.split(' ').last)
      @cliente.cantidadrecom += 1
      @cliente.update_attributes(cantidadrecom: @cliente.cantidadrecom)
    end
  end
  
  def self.happyverde
    @clientes = Cliente.all
    @clientes.each do |clien|
      @cliente = clien
      mes = @cliente.nacimiento.to_s.split('-')[1].to_i
      dia = @cliente.nacimiento.to_s.split('-')[2].to_i
      if mes == Date.today.month && dia == Date.today.day
        MyMailer.feliz_cumple(clien).deliver
      end
    end
    
  end
  
  
  
end
