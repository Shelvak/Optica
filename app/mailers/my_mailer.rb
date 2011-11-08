class MyMailer < ActionMailer::Base
  # default from: "nestorcoppi@gmail.com"
 default from: "coppistrike@yahoo.com.ar",
  :charset => "UTF-8"
  # :content_type => "text/plain"

  
  def enviar(to,subject,body)
  	to = to.join
  	#body = sanitize(body)
    @destinatarios = Cliente.where("lente = ?", "#{to}").map(&:email).compact if to != 'todos'
    @destinatarios = Cliente.all.map(&:email).compact if to == 'todos'
    @body = body
    mail(
      :bcc => @destinatarios,
      :subject => subject,
      :body => body) 
  end
  
  
end
