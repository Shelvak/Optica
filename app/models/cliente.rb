class Cliente < ActiveRecord::Base
  before_save :camel, :verificar_documento
  has_many :historials
  #has_many :receta
  
  #scope :con_nombre, lambda { |nombre| where('LOWER(nombre) LIKE ?', "#{nombre}%".downcase) }
  scope :busqueda, lambda { |buscar| where('documento LIKE ?', "#{buscar}%") }
  
  validate :nombre, :apellido, :documento, presence: true
  validate :documento, uniqueness: true
  
  def camel
    self.nombre = self.nombre.split.map(&:camelize).join(' ')
    self.apellido = self.apellido.split.map(&:camelize).join(' ')
  end
  
  def to_s 
		self.nombre + ' ' + self.apellido + ' ' + self.documento
    #self.documento
	end
  
  def verificar_documento
    self.documento = self.documento.split('.').join
  end
  
end
