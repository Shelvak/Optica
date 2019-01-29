class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  scope :enabled, -> { where(enabled: true) }

  default_scope -> { enabled }

  before_save :asignar_admin

  def asignar_admin
    @a = User.all
    self.admin = true unless @a.present?
  end

end
