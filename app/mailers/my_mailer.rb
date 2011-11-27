class MyMailer < ActionMailer::Base
  default from: "nestorcoppi@gmail.com",
 #default from: "coppistrike@yahoo.com.ar",
  :charset => "UTF-8",
  :content_type => "text/html"

  
  def enviar(to,subject,body)
  	to = to.join
    
    @destinatarios = Cliente.where("lente = ?", "#{to}").map(&:email).compact if to != 'todos'
    @destinatarios = Cliente.all.map(&:email).compact if to == 'todos'
    @body = body
    
    # attachments.inline['IBM.jpg'] = File.read("#{Rails.root}/public/IBM.jpg")

    mail(
      :bcc => @destinatarios,
      :subject => subject,
      :body => @body)
    
  end
  
  def feliz_cumple(clien)
    @cliente = clien
    attachments.inline['IBM.jpg'] = File.read("#{Rails.root}/public/IBM.jpg")
    mail(to: @cliente.email, subject: "Muy feliz cumpleanios #{@cliente.nombre.camelize}" )
    end
  
  
end
