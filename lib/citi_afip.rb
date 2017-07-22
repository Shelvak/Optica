module CitiAfip

  def lalala(month)
    bills = Bill.where(created_at: month.beginning_of_month..month.end_of_month)

    ventas = bills.map { |b| venta(b) }

    body = (ventas + [header]).flatten.join("\n")

    File.open('milonga.txt', 'w') {|f| f.write(body)}
  end

  def header
    [
      cuit,
      periooA
      cuit, # CUIT Informante
      date(), # Período
      00,  # Secuencia
      N,   # Sin Movimiento
      N,   # Prorratear Crédito Fiscal Computable
      2,   # Crédito Fiscal Computable Global ó Por Comprobante
      000, # Importe Crédito Fiscal Computable Global
      000, # Importe Crédito Fiscal Computable, con asignación directa.
      000, # Importe Crédito Fiscal Computable, determinado por prorrateo.
      000, # Importe Crédito Fiscal no Computable Global
      000, # Crédito Fiscal Contrib. Seg. Soc. y Otros Conceptos
      000  # Crédito Fiscal Computable Contrib. Seg. Soc. y Otros Conceptos
    ].join
  end

  def venta(bill)
    [
      date(bill.billed_date), # Fecha de comprobante (8)
      r(bill., 3), # Tipo de comprobante (3)
			r(sale_point, 5), # Punto de venta (5)
			r(num_min, 20), # Número de comprobante (20)
			r(num_max, 20), # Número de comprobante hasta (20)
      Snoopy::DOCUMENTS[bill.client.document_type], # Código de documento del comprador (2)
			r(doc_number, 20), # Número de identificación del comprador (20)
			full_name, # Apellido y nombre del comprador (30)
			d(total), # Importe total de la operación (15)
			d(??), # Importe total de conceptos que no integran el precio neto gravado (15)
			d(??), # Percepción a no categorizados (15)
			d(??), # Importe operaciones exentas (15)
			d(??), # Importe de percepciones o pagos a cuenta de impuestos nacionales (15)
			d(??), # Importe de percepciones de ingresos brutos (15)
			d(??), # Importe de percepciones impuestos municipales (15)
			d(??), # Importe impuestos internos (15)
			currency, # Código de Moneda (3)
			d(??, 10),# Tipo de cambio (10)
			, # Cantidad de alícuotas de IVA (1)
			# Código de operación (1)
			# Otros Tributos (15)
			date(due_date)  # Fecha de vencimiento de pago (8)
		]
	end

  ##### HELPERS  #####
  def date(_date)
    _date.strftime('%Y%m%d')
  end

  def r num, fit
    num.to_s.rjust(fit, '0')
  end

  def d num, precision=15
    (num.to_f * 100).round.to_i.to_s.rjust(precision, '0')
  end
end
