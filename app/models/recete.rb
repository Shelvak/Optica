class Recete < ActiveRecord::Base
  has_one :historial
  scope :histori, lambda { |id| where("historial_id = #{id}")}
  
end
