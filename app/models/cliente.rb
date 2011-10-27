class Cliente < ActiveRecord::Base
  before_save :camel
  has_many :historials
  #has_many :receta
  
  scope :con_documento, lambda { |documento| where('documento LIKE ?', "#{documento}%") }
  
  validate :nombre, :apellido, :documento, presence: true
  validate :documento, uniqueness: true
  
  def camel
    self.nombre = self.nombre.split.map(&:camelize).join(' ')
    self.apellido = self.apellido.split.map(&:camelize).join(' ')
  end
  
  def to_s 
		self.nombre
	end
  
end
