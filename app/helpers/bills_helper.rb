module BillsHelper
  def paid_via_collection
    Bill::PAID_VIA.map do |key|
      [I18n.t('view.bills.paid_via.'+ key), key]
    end
  end

  def invoicing_firm_info_for(bill)
    cuit = bill.cuit.to_s
    iibb = bill.cuit_old? ? '0486404' : '0821022'
    start = bill.cuit_old? ? '10/04/2003' : '01/05/2019'

    [
      content_tag(:p, "CUIT: #{cuit[0..1]}-#{cuit[2..-2]}-#{cuit[-1]}"),
      content_tag(:p, "Ingresos Brutos: #{iibb}"),
      content_tag(:p, "Inicio de actividades: #{start}")
    ].join().html_safe
  end
end
