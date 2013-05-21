Optica::Application.configure do
   config.action_mailer.delivery_method = :smtp
   config.action_mailer.perform_deliveries = true
   config.action_mailer.raise_delivery_errors = true
   config.action_mailer.smtp_settings = APP_CONFIG['smtp'].symbolize_keys
end
# for fucking send error
class Array
  def encoding
  end
  def encode!(x)
    x
  end
end
