class CreditNote < ApplicationRecord

  CREDIT_NOTES = {
    'A' => :nota_credito_a,
    'B' => :nota_credito_b,
    'C' => :nota_credito_c
  }

  belongs_to :bill

  validates :cae, :bill_id, presence: true

  delegate :data_for_afip, to: :bill

  def authorize_against_afip!
    data = self.data_for_afip.merge(SECRETS[:AFIP_DATA]).with_indifferent_access

    data[:cbte_asoc_pto_venta] = bill.sale_point
    data[:cbte_asoc_num] = bill.number
    data[:iva_cond] = CREDIT_NOTES[bill.bill_type]

    snoopy_bill = Snoopy::Bill.new(data)
    snoopy_bill.cae_request
    if snoopy_bill.aprobada?
      byebug
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
end
