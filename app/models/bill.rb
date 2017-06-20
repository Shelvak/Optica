class Bill < ActiveRecord::Base
  require 'snoopy_afip'
  Snoopy.auth_url    = "https://wsaa.afip.gov.ar/ws/services/LoginCms"
  Snoopy.service_url =  './prod.wsdl' #lib_path + '/files/prod.wsdl'
  Snoopy.default_moneda    = :peso
  Snoopy.default_concepto  = 'Productos y Servicios'
  Snoopy.default_documento = 'CUIT'

  BILL_TYPES = {
    'A' => :factura_a,
    'B' => :factura_b,
    'C' => :factura_c
  }

  before_save :recalc_vat_values
  #before_create :authorize_against_afip

  belongs_to :client, class_name: Cliente
  belongs_to :historial

  has_many :bill_items

  accepts_nested_attributes_for :bill_items, reject_if: ->(attrs) {
    attrs['quantity'].to_i == 0 && attrs['amount'].to_f == 0.0
  }

  def initialize(attrs={})
    super(attrs)

    self.number ||= 1
    self.cae ||= 1
    self.vat ||= 21.0
  end

  def build_from_historial
    h = self.historial
    self.client_id = h.cliente_id
    self.historial_id = h.id
    self.amount = h.precio
    self.bill_items.build(
      description: h.description,
      amount: h.precio
    )
    self
  end

  def data_for_afip
    data = {}
    data[:doc_num] = self.client.document_number
    data[:documento] = self.client.document_type
    data[:iva_cond] = BILL_TYPES[self.client.bill_type]
    # Opcional
    #data[:fch_serv_desde] = data[:fch_serv_hasta] = Date.today.strftime('%Y%m%d')

    data[:imp_iva] = (self.amount*0.21).round(2)
    data[:net] = self.amount
    data[:net] -= data[:imp_iva] if self.client.bill_type != 'B'

    data[:alicivas] = [
      {
        id: 0.21,  importe: data[:imp_iva], base_imp: data[:net]
      }
    ]
    p "ROck"
    p data
    data
  end

  def authorize_against_afip
    return
    data = self.data_for_afip.merge(SECRETS[:AFIP_DATA]).with_indifferent_access

    bill = Snoopy::Bill.new(data)
    bill.cae_request
    if bill.aprobada?
      self.assign_from_afip_response(bill)
    else
      snoopy_bill.response
      self.errors.add(:base, "Hubo un error")
      self.errors.add(:afip_error, bill.errors.join("\n"))
      self.errors.add(:afip_observations, bill.observaciones)
      false
    end
  end

  def assign_from_afip_response(snoopy_bill)
    self.cae = snoopy_bill.cae
    self.number = snoopy_bill.numero
    self.sale_point = snoopy_bill.punto_venta
    self.billed_date = snoopy_bill.fecha_comprobante
  end

  def total_amount
    self.bill_items.to_a.map(&:total_amount).sum
  end

  def recalc_vat_values
    amount = self.total_amount
    self.vat_amount = (amount * (self.vat/100))
  end
end

#case kind_invoice
#when Invoicing::KindInvoice::ArgentinaA.name
#errors.add(:kind_invoice, "No podes hacer A") unless (invoicing_firm.responsable_inscripto? and responsable_inscripto?)
#when Invoicing::KindInvoice::ArgentinaB.name
#errors.add(:kind_invoice, "No podes hacer B") unless (invoicing_firm.responsable_inscripto? and not responsable_inscripto?)
#when Invoicing::KindInvoice::ArgentinaC.name
#errors.add(:kind_invoice, "No podes hacer C") unless invoicing_firm.monotributista
#end
