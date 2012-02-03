class User < ActiveRecord::Base
  acts_as_authentic
  
  before_save :asignar_admin
  
  def asignar_admin
    @a = User.all
    self.admin = true unless @a.present?
  end
  
end
