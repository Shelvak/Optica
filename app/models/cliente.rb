class Cliente < ActiveRecord::Base
  before_save :camel
  
  has_many :historials
  has_many :recetum
  
  validate :nombre, :apellido, :documento, presence: true
  validate :documento, uniqueness: true
  
  def camel
    self.nombre = self.nombre.split.map(&:camelize).join(' ')
    self.apellido = self.apellido.split.map(&:camelize).join(' ')
  end
  
end
