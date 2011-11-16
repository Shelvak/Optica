class Recete < ActiveRecord::Base
  belongs_to :historial
  scope :histori, lambda { |id| where("historial_id = #{id}")}
  
#  before_save :asignar_distancia
#  
#  def asignar_distancia
#    self.distancia = true if self.distancia == 'De Lejos'
#    self.distancia = false if self.distancia == 'De Cerca'
#  end
#  
end
