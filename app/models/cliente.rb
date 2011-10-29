class Cliente < ActiveRecord::Base
  before_save :camel, :verificar_documento, :asignar_cantidadrecom
  before_validation :asignar_recomendado
  has_many :historials
  #has_many :receta
  
  
  attr_accessor :auto_recomendado
  
  
  scope :con_documento, lambda { |buscar| where('documento LIKE ?', "#{buscar}%") }
  scope :con_nombre, lambda { |nombre| where('LOWER(nombre) LIKE ?', "#{nombre}%".downcase)}
  
  validate :nombre, :apellido, :documento, presence: true
  validate :documento, uniqueness: true
  
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
  
end
