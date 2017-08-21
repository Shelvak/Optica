class MyMailer < ActionMailer::Base
  default from: "Optica Palpacelli <info@opticapalpacelli.com.ar>",
    charset: "UTF-8",
    content_type: "text/html"


  def enviar(destinatarios, subject, body)
    @body = body
    @destinatarios = destinatarios
    if destinatarios && destinatarios.size > 0
      mail(
        bcc: @destinatarios,
        subject: subject,
        body: @body
      )
    end
  end

  def feliz_cumple(client_id)
    cliente = Client.find(client_id)
    attachments.inline['cumple.jpg'] = File.read("#{Rails.root}/public/cumple.jpg")
    mail(
      to: cliente.email,
      subject: "Optica Palpacelli te desea un feliz cumple #{cliente.nombre.camelize}"
    )
  end

  def felices_fiestas(cliente)
    #attachments.inline['fiestas.jpg'] = File.read("#{Rails.root}/public/fiestas.jpg")
    #  mail(to: cliente.email, subject: "Optica Palpacelli les desea muy felices fiestas #{cliente.nombre.camelize}!!! " )
  end


  def fiestas
    #@clientes = Cliente.all
    #@clientes.each do |cliente|
    #  MyMailer.felices_fiestas(cliente).deliver if (Date.today.day == 24 && Date.today.month == 12)
    #end
  end

  def all_bills
    require 'citi_afip'
    date = Time.new.advance(months: -1)
    @formatted_date = I18n.l(date.to_date, format: "%B-%Y")
    filenames = CitiAfip.generate_files(date)

    filenames.each do |file|
      attachments[file.to_s.split('/').last] = File.read(file)
    end
    milonga = [[
      'Fecha',
      'Cod Cliente',
      'Cliente',
      'Cond Iva',
      'Tipo Doc',
      'Nro Doc',
      'Tipo Compr',
      'Nro Compr',
      'Porc IVA',
      'Imp Excento',
      'Imp Neto',
      'Imp IVA',
      'TOTAL'
    ].join(',')]

    milonga += Bill.where(created_at: date.beginning_of_month..date.end_of_month).map(&:to_accountant)
    milonga += CreditNote.where(created_at: date.beginning_of_month..date.end_of_month).map(&:to_accountant)

    attachments["libro-#{@formatted_date}.xls"] = milonga.join("\r\n")

    mail(
      to: 'antonio@martinscordia.com.ar',
      subject: "Optica Palpacelli - Archivos CITI - #{@formatted_date}",
      body: "Optica Palpacelli - Archivos CITI - #{@formatted_date}"
    )
  end
end
