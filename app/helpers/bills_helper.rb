module BillsHelper
  def paid_via_collection
    Bill::PAID_VIA.map do |key|
      [I18n.t('view.bills.paid_via.'+ key), key]
    end
  end
end
