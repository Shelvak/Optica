module CitiAfip
  extend self

  EOL = "\r\n"

  def generate_files(month=Time.new.advance(months: -1))
    bills = [
      Bill.where(created_at: month.beginning_of_month..month.end_of_month).to_a,
      CreditNote.where(created_at: month.beginning_of_month..month.end_of_month).to_a
    ].flatten
    p "Generating #{bills.size} count"

    headers   = bills.map { |b| header(b) }
    headers   << headers_summary(bills, headers, month)
    cbtes     = bills.map { |b| cbte(b) }.join(EOL)
    alicuotas = bills.map { |b| alicuota(b) }.join(EOL)
    details   = bills.map { |b| bill_details(b) }.flatten.join(EOL)

    identifier = I18n.l(month.to_date, format: '%B-%Y')
    filenames = []

    {
      'REGINFO_CV_CABECERA':         headers.join(EOL),
      'REGINFO_CV_VENTAS_CBTE':      cbtes,
      'REGINFO_CV_VENTAS_ALICUOTAS': alicuotas,
      'REGINFO_CV_VENTAS_DETALLES':  details
    }.each do |file, body|
      filepath = Rails.root.join("private/#{file}-#{identifier}.txt")
      filenames << filepath
      File.open(filepath, 'w') { |f| f.write(body) }
    end

    filenames
  end

  def header(bill)
    billed_date = date(bill.try(:billed_date) || bill.created_at) # Período
    void_date = bill.try(:bill_id) ? date(bill.due_date) : (' ' * 8)
    [
      '1',  # tipo de registro ?
      billed_date,
      bill_type_for(bill, 2), # tipo comprobante
      ' ', # Contr Fiscal
      r(bill.sale_point, 4),        # Punto de venta (5)
      r(bill.number, 8),            # Número de comprobante (20)
      r(bill.number, 8),            # Número de comprobante (20)
      r(1, 3),  # Cant de hojas
      document_type_for(bill), # Codigo de documento
      document_number_for(bill, 11), # Número de identificación del comprador (11)
      full_name(bill),
      d(bill.total_amount),
      d(0),
      d(bill.net_amount),  # importe neto gravado
      d(0), # Imp liquidado
      d(0), # no categorizados
      d(0), # exentas
      d(0), # percepciones o pagos
      d(0), # # IIBB
      d(0), # Munucipales
      d(0), # impuestos internos
      d(0), # Transporte
      (bill.bill_type == 'A' ? '01' : '05'), # 01 Iva Resp no inscripto 05 Cons Final
      'PES',
      '0001000000',
      '1',
      ' ',
      bill.cae,
      date(bill.try(:due_date) || bill.try(:billed_date) || bill.created_at),
      void_date
    ].join
  end

  def headers_summary(bills, headers, month)
    [
      '2',
      month.strftime('%Y%m'), # Período
      ' '*13,
      r(headers.size, 8),
      ' '*17,
      SECRETS[:AFIP_DATA]['cuit'], # CUIT Informante
      ' '*22,
      d(bills.sum(&:total_amount)),
      d(0),
      d(bills.sum(&:net_amount)),
      d(0), # liqui
      d(0), # no cat
      d(0), # exentas
      d(0), # pagos
      d(0), # IIGBB
      d(0), # Municipales
      d(0), # Internos
      ' '*62
    ].join
  end

  # Ya no sirve mas
  def old_header(month)
    [
      SECRETS[:AFIP_DATA]['cuit'], # CUIT Informante
      month.strftime('%Y%m'), # Período
      '00',  # Secuencia
      'N',   # Sin Movimiento
      'N',   # Prorratear Crédito Fiscal Computable
      2,   # Crédito Fiscal Computable Global ó Por Comprobante
      d(''), # Importe Crédito Fiscal Computable Global
      d(''), # Importe Crédito Fiscal Computable, con asignación directa.
      d(''), # Importe Crédito Fiscal Computable, determinado por prorrateo.
      d(''), # Importe Crédito Fiscal no Computable Global
      d(''), # Crédito Fiscal Contrib. Seg. Soc. y Otros Conceptos
      d('')  # Crédito Fiscal Computable Contrib. Seg. Soc. y Otros Conceptos
    ].join
  end

  def cbte(bill)
    billed_date = date(bill.try(:billed_date) || bill.created_at)
    [
      billed_date,               # Fecha de comprobante (8)
      bill_type_for(bill),       # Tipo de comprobante (3)
      r(bill.sale_point, 5),     # Punto de venta (5)
      r(bill.number, 20),        # Número de comprobante (20)
      r(bill.number, 20),        # Número de comprobante hasta (20)
      document_type_for(bill),   # Código de documento del comprador (2)
      document_number_for(bill), # Número de identificación del comprador (20)
      full_name(bill),           # Apellido y nombre del comprador (30)
      d(bill.total_amount),      # Importe total de la operación (15)
      d(0),                      # Importe total de conceptos que no integran el precio neto gravado (15)
      d(0),                      # Percepción a no categorizados (15)
      d(0),                      # Importe operaciones exentas (15)
      d(0),                      # Importe de percepciones o pagos a cuenta de impuestos nacionales (15)
      d(0),                      # Importe de percepciones de ingresos brutos (15)
      d(0),                      # Importe de percepciones impuestos municipales (15)
      d(0),                      # Importe impuestos internos (15)
      'PES',                     # Código de Moneda (3)
      '0001000000',              # Tipo de cambio (10) (4 enteros 6decimales)
      1,                         # Cantidad de alícuotas de IVA (1)
      ' ',                       # Código de operación (1)
      d(0),                      # Otros Tributos (15)
      billed_date     # Fecha de vencimiento de pago (8)
    ].join
  end

  def alicuota(bill)
    [
      bill_type_for(bill),          # Tipo de comprobante (3)
      r(bill.sale_point, 5),        # Punto de venta (5)
      r(bill.number, 20),           # Número de comprobante (20)
      d(bill.net_amount),                # Importe neto gravado
      r(Snoopy::ALIC_IVA[0.21], 4), # Alicuota de IVA
      d(bill.vat_amount)            # Impuesto Liquidado
    ].join
  end

  def bill_details(bill)
    # cod factura | fecha| pto vta | nro factura | nro factura | cantidad 7,5 | un de medida |  precio 13,3 | boonificacion (0) | ajuste (0) | subtotal | alicuota iva

    billed_date = date(bill.try(:billed_date) || bill.created_at)

    bill.bill_items.map do |item|
      [
        bill_type_for(bill, 2),       # Tipo de comprobante (2)
        ' ',                          # Ctrolador fiscal
        billed_date,                  # Fecha de comprobante (8)
        r(bill.sale_point, 4),        # Punto de venta (5)
        r(bill.number, 8),            # Número de comprobante (20)
        r(bill.number, 8),            # Número de comprobante hasta (20)
        r(item.quantity.to_i, 7),     # Cantidad entera [siempre entera] (7)
        r('', 5),                     # Cantidad decimal [siempre entera] (5)
        '07',                         # unidad de medida [Unidad siempre] (2)
        r(item.amount.to_i, 13),            # Importe item entero (13)
        r((item.amount.frac * 1000).round(3).to_i, 3), # Importe item decimal (3)
        r('', 15),                    # Importe bonificacion (16)
        r('', 16),                    # Importe ajuste (16)
        r(item.sub_net_amount.to_i, 13), # Importe subtotal entero (16)
        l((item.sub_net_amount.frac.round(3) * 1000).to_i, 3), # Importe subtotal decimal (3)
        r(Snoopy::ALIC_IVA[bill.vat.to_f / 100], 4), # Alicuota de IVA
        '  ',
        transliterate(item.description, 75) # DETALLE
      ].join
    end
  end

  ##### HELPERS  #####
  def date(_date)
    _date.strftime('%Y%m%d')
  end

  def r num, fit
    # Delete possible non-num
    num.to_s.gsub(/\D+/, '').rjust(fit, '0')
  end

  def l num, fit
    # Delete possible non-num
    num.to_s.gsub(/\D+/, '').ljust(fit, '0')
  end

  def d num, precision=15
    (num.to_f * 100).round.to_i.to_s.rjust(precision, '0')
  end

  def full_name(bill)
    transliterate(bill.client.try(:to_name) || '', 30)[0..29]
  end

  def document_type_for(bill)
    afip_response_for(bill)['fe_det_resp']['fecae_det_response']['doc_tipo']
  rescue => e
    p "ROCK VIEJAAA doc type", e
    Snoopy::DOCUMENTOS[bill.client.document_type]
  end

  def document_number_for(bill, n=20)
    r(afip_response_for(bill)['fe_det_resp']['fecae_det_response']['doc_nro'], n)
  rescue => e
    p "ROCK VIEJAAA doc num", e
    r(bill.client.document_number, 20)
  end

  def bill_type_for(bill, n=3)
    r(afip_response_for(bill)['fe_cab_resp']['cbte_tipo'], n)
  rescue => e
    p "ROCK VIEJAAA bill_type", e
    r(Snoopy::BILL_TYPE[Bill::BILL_TYPES[bill.bill_type]], 3)
  end

  def afip_response_for(bill)
    (bill.try(:afip_response) || bill.try(:response))['fecae_solicitar_response']['fecae_solicitar_result']
  end

  def transliterate(string, length)
    I18n.transliterate(string).ljust(length, ' ')[0..(length - 1)]
  end
end
