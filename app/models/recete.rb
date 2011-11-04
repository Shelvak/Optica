class Recete < ActiveRecord::Base
  belongs_to :historial
  scope :histori, lambda { |id| where("historial_id = #{id}")}
  
end
