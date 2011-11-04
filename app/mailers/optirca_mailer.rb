class OptircaMailer < ActionMailer::Base
  default from: "coppistrike@yahoo.com.ar"
  
  def enviar_a_contactos(asunto, mensaje)
    @destinatarios = Clientes.where('contacto == TRUE')
    mail(to: @destinatarios,
      subject: asunto,
      body: mensaje
    )
  end
end
