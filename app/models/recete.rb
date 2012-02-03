class Recete < ActiveRecord::Base
  has_one :historial
  scope :histori, lambda { |id| where("historial_id = #{id}")}
  
  
  validates :esferico, :cilindrico, :eje, :diametro, :adicion, allow_nil: true, 
          allow_blank: true , numericality: true
end
