class MyMailer < ActionMailer::Base
  default from: "nestorcoppi@gmail.com",
 #default from: "coppistrike@yahoo.com.ar",
  :charset => "UTF-8",
  :content_type => "text/html"

  
  def enviar(to,subject,body,file)
  	to = to.join
  	#body = sanitize(body)
    @destinatarios = Cliente.where("lente = ?", "#{to}").map(&:email).compact if to != 'todos'
    @destinatarios = Cliente.all.map(&:email).compact if to == 'todos'
    @body = body.html_safe
    # attachments.inline['IBM.jpg'] = File.read("#{Rails.root}/public/IBM.jpg")

    mail(
      :bcc => @destinatarios,
      :subject => subject,
      :body => @body)
    
  end
  
  def felizcumple(cliente)
    @cliente = cliente
    mail(to: @cliente.email, subject: 'Muy feliz cumpleaños')
  end
  
  
end
