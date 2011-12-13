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
  
  def felices_fiestas(cliente)
    attachments.inline['fiestas.jpg'] = File.read("#{Rails.root}/public/fiestas.jpg")
      mail(to: cliente.email, subject: "Muy felices fiestas #{cliente.nombre.camelize}!!! " )
  end
  
  
  def fiestas
    @clientes = Cliente.all
    @clientes.each do |cliente| 
      MyMailer.felices_fiestas(cliente).deliver if (Date.today.day == 24 && Date.today.month == 12)
    end
  end
  
end
