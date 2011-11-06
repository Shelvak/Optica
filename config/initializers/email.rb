#encoding: UTF-8
Optica::Application.configure do
   config.action_mailer.delivery_method = :smtp
   config.action_mailer.perform_deliveries = true
   config.action_mailer.raise_delivery_errors = false
   #config.action_mailer.default_charset = "utf-8"
#   config.action_mailer.smtp_settings = {
#     address: 'smtp.mail.yahoo.com',
#     port: 587,
#     domain: 'yahoo.com.ar',
#     user_name: 'coppistrike@yahoo.com.ar',
#     password: 'magicad',
#     authentication: 'plain',
#    enable_starttls_auto: true
#  }
   config.action_mailer.smtp_settings = {
     address: 'smtp.gmail.com',
     port: 587,
#     domain: 'yahoo.com.ar',
     user_name: 'nestorcoppi',
     password: 'laconchadetumadre',
     authentication: 'plain',
    enable_starttls_auto: true
  }
end

