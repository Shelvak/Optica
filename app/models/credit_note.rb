class CreditNote < ApplicationRecord

  CREDIT_NOTES = {
    'A' => :nota_credito_a,
    'B' => :nota_credito_b,
    'C' => :nota_credito_c
  }

  after_commit :assign_to_global_sales, on: :create

  belongs_to :bill

  validates :cae, :bill_id, presence: true

  delegate :data_for_afip, to: :bill
  delegate :gross, to: :bill
  delegate :sale_point, to: :bill
  delegate :total_amount, to: :bill
  delegate :vat_amount, to: :bill
  delegate :client, to: :bill
  delegate :bill_type, to: :bill
  delegate :sell_type, to: :bill

  def authorize_against_afip!
    data = self.data_for_afip.merge(SECRETS[:AFIP_DATA]).with_indifferent_access

    data[:cbte_asoc_pto_venta] = bill.sale_point
    data[:cbte_asoc_num] = bill.number
    data[:iva_cond] = CREDIT_NOTES[bill_type]

    snoopy_bill = Snoopy::Bill.new(data)
    snoopy_bill.cae_request
    if snoopy_bill.aprobada?
      self.assign_from_afip_response(snoopy_bill)
    else
      self.errors.add(:base, "Hubo un error")
      self.errors.add(:afip_error, snoopy_bill.errors)
      self.errors.add(:afip_observations, snoopy_bill.observaciones)
      false
    end
  end

  def assign_from_afip_response(snoopy_bill)
    self.cae = snoopy_bill.cae
    self.number = snoopy_bill.numero
    self.due_date = Date.parse snoopy_bill.vencimiento_cae
    self.request = snoopy_bill.body['FeCAEReq']
    self.response = snoopy_bill.response
    self.save
  end

  def number_with_sale_point
    [
      bill.sale_point.to_s.ljust(4, '0'),
      number.to_s.rjust(8, '0')
    ].join('-')
  end

  def to_accountant
    helper = ActionController::Base.helpers

    [
      self.created_at.strftime("%d-%m-%Y"),
      self.client.try(:id),
      self.client.try(:to_name),
      self.client.try(:vat_condition),
      self.client.try(:document_type),
      self.client.try(:document_number),
      "NC #{self.bill_type}",
      self.number_with_sale_point,
      21,
      0,
      self.gross,
      self.vat_amount,
      self.total_amount
    ].join(',')
  end

  def assign_to_global_sales
    venta = Venta.find_by(
      month: bill.created_at.month, year: bill.created_at.year
    )
    venta.decrease_by_type(sell_type, self.total_amount)
    venta.save

    self.client.gastado -= self.total_amount
    self.client.save
  rescue
    nil
  end
end
