# enconding: UTF-8
class MyMailer < ActionMailer::Base
  default from: "nestorcoppi@gmail.com",
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
    attachments.inline['cumple.jpg'] = File.read("#{Rails.root}/public/cumple.jpg")
    mail(to: @cliente.email, subject: "Muy feliz cumple #{@cliente.nombre.camelize}" )
  end
  
  def feliz_navidad(cliente)
    attachments.inline['navidad.jpg'] = File.read("#{Rails.root}/public/navidad.jpg")
      mail(to: cliente.email, subject: "Muy feliz navidad #{cliente.nombre.camelize}!!! " )
  end
  
  def feliz_anio(cliente)
      attachments.inline['anio_nuevo.jpg'] = File.read("#{Rails.root}/public/anio_nuevo.jpg")
      mail(to: cliente.email, subject: "Muy feliz anio nuevo #{cliente.nombre.camelize}!!!" )
  end
  
  def fiestas
    @clientes = Cliente.all
    @clientes.each do |cliente| 
      MyMailer.feliz_navidad(cliente).deliver if (Date.today.day == 24 && Date.today.month == 12)
      MyMailer.feliz_anio(cliente).deliver if (Date.today.day == 31 && Date.today.month == 12)
    end
  end
  
end
