class Recete < ActiveRecord::Base
  has_one :historial
  scope :histori, lambda { |id| where("historial_id = #{id}")}
  
  
  validates :precio, :orden, :esferico, :cilindrico, :eje, :diametro, :adicion, presence: true, numericality: true
end
