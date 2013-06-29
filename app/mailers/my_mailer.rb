class MyMailer < ActionMailer::Base
  default from: "Optica Palpacelli <info@opticapalpacelli.com.ar>",
  :charset => "UTF-8",
  :content_type => "text/html"

  
  def enviar(to,subject,body)
    @destinatarios = Cliente.where(lente: to).map(&:email).uniq if to != 'todos'
    @destinatarios = Cliente.all.map(&:email).uniq if to == 'todos'
    @body = body
    @destinatarios.compact!
    @destinatarios.delete('')
    @destinatarios.delete(' ')
    %x{echo #{@destinatarios} > lala}
    mail(
      :bcc => @destinatarios,
      :subject => subject,
      :body => @body)
  end
  
  def feliz_cumple(clien)
    @cliente = clien
    attachments.inline['cumple.jpg'] = File.read("#{Rails.root}/public/cumple.jpg")
    mail(to: @cliente.email, subject: "Optica Palpacelli te desea un feliz cumple #{@cliente.nombre.camelize}" )
  end
  
  def felices_fiestas(cliente)
    attachments.inline['fiestas.jpg'] = File.read("#{Rails.root}/public/fiestas.jpg")
      mail(to: cliente.email, subject: "Optica Palpacelli les desea muy felices fiestas #{cliente.nombre.camelize}!!! " )
  end
  
  
  def fiestas
    @clientes = Cliente.all
    @clientes.each do |cliente| 
      MyMailer.felices_fiestas(cliente).deliver if (Date.today.day == 24 && Date.today.month == 12)
    end
  end
  
end
