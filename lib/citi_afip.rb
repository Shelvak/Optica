module CitiAfip
  extend self

  EOL = "\r\n"

  def generate_files(month=Time.new.advance(months: -1))
    bills = [
      Bill.where(created_at: month.beginning_of_month..month.end_of_month).to_a,
      CreditNote.where(created_at: month.beginning_of_month..month.end_of_month).to_a
    ].flatten
    p "Generating #{bills.size} count"

    cbtes = bills.map { |b| cbte(b) }.join(EOL)
    alicuotas = bills.map { |b| alicuota(b) }.join(EOL)

    random_number = Time.new.to_i
    filenames = []

    {
      'REGINFO_CV_CABECERA': header(month),
      'REGINFO_CV_VENTAS_CBTE': cbtes,
      'REGINFO_CV_VENTAS_ALICUOTAS': alicuotas
    }.each do |file, body|
      filepath = Rails.root.join("private/#{file}-#{random_number}.txt")
      filenames << filepath
      File.open(filepath, 'w') { |f| f.write(body) }
    end

    filenames
  end

  def header(month)
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
      billed_date,    # Fecha de comprobante (8)
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
      d(bill.gross),                # Importe neto gravado
      r(Snoopy::ALIC_IVA[0.21], 4), # Alicuota de IVA
      d(bill.vat_amount)            # Impuesto Liquidado
    ].join
  end

  ##### HELPERS  #####
  def date(_date)
    _date.strftime('%Y%m%d')
  end

  def r num, fit
    # Delete possible non-num
    num.to_s.gsub(/\D+/, '').rjust(fit, '0')
  end

  def d num, precision=15
    (num.to_f * 100).round.to_i.to_s.rjust(precision, '0')
  end

  def full_name(bill)
    I18n.transliterate(bill.client.to_name).to_s[0..29].ljust(30, ' ')
  end

  def document_type_for(bill)
    afip_response_for(bill)['fe_det_resp']['fecae_det_response']['doc_tipo']
  rescue => e
    p "ROCK VIEJAAA doc type", e
    Snoopy::DOCUMENTOS[bill.client.document_type]
  end

  def document_number_for(bill)
    r(afip_response_for(bill)['fe_det_resp']['fecae_det_response']['doc_nro'], 20)
  rescue => e
    p "ROCK VIEJAAA doc num", e
    r(bill.client.document_number, 20)
  end

  def bill_type_for(bill)
    r(afip_response_for(bill)['fe_cab_resp']['cbte_tipo'], 3)
  rescue => e
    p "ROCK VIEJAAA bill_type", e
    r(Snoopy::BILL_TYPE[Bill::BILL_TYPES[bill.bill_type]], 3)
  end

  def afip_response_for(bill)
    (bill.try(:afip_response) || bill.try(:response))['fecae_solicitar_response']['fecae_solicitar_result']
  end
end