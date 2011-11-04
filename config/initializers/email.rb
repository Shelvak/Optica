#encoding: UTF-8
Optica::Application.configure do
   config.action_mailer.delivery_method = :smtp
   config.action_mailer.smtp_settings = {
     address: 'smtp.mail.yahoo.com',
     port: 587,
     domain: 'yahoo.com.ar',
     user_name: 'coppistrike@yahoo.com.ar',
     password: 'magicad',
     authentication: 'plain',
    enable_starttls_auto: true
  }
end

