class Bill < ActiveRecord::Base
  require 'snoopy_afip'
  Snoopy.auth_url    = "https://wsaahomo.afip.gov.ar/ws/services/LoginCms"
  Snoopy.service_url =  './testing.wsdl' #lib_path + '/files/prod.wsdl'
  Snoopy.default_moneda    = :peso
  Snoopy.default_concepto  = 'Productos y Servicios'
  Snoopy.default_documento = 'CUIT'

  BILL_TYPES = {
    'A' => :factura_a,
    'B' => :factura_b,
    'C' => :factura_c
  }
  VAT_CONDITIONS = [
    'CONSUMIDOR FINAL',
    'IVA RESPONSABLE INSCRIPTO',
    'IVA RESPONSABLE NO INSCRIPTO',
    'NO RESPONSABLE',
    'IVA EXENTO',
    'RESPONSABLE MONOTRIBUTO',
    'SUJETO NO CATEGORIZADO',
    'MONOTRIBUTISTA SOCIAL',
    'PEQUEÑO CONTRIBUYENTE EVENTUAL',
    'PEQUEÑO CONTRIBUYENTE EVENTUAL SOCIAL',
  ]

  before_save :recalc_vat_values
  before_create :authorize_against_afip

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
    self.vat = 21.0
    self.bill_type ||= self.client.try(:bill_type) || 'B'
    self.client_vat_condition = self.client.vat_condition
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
    data[:iva_cond] = BILL_TYPES[self.bill_type]

    data[:net] = (self.total_amount/1.21).round(2) # - data[:imp_iva]).round(2)
    importe = (self.total_amount - data[:net]).round(2)

    data[:alicivas] = [
      {
        id: 0.21,  importe: importe, base_imp: data[:net]
      }
    ]
    data
  end

  def authorize_against_afip
    data = self.data_for_afip.merge(SECRETS[:AFIP_DATA]).with_indifferent_access

    bill = Snoopy::Bill.new(data)
    bill.cae_request
    if bill.aprobada?
      self.assign_from_afip_response(bill)
    else
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
    self.cae_due_date = snoopy_bill.vencimiento_cae
    self.afip_response = snoopy_bill.response
  end

  def total_amount
    self.bill_items.to_a.map(&:total_amount).sum
  end

  def gross
    self.total_amount / 1.21
  end

  def recalc_vat_values
    self.vat_amount = total_amount - gross
  end

  def number_with_sale_point
    [
      sale_point.to_s.ljust(4, '0'),
      number.to_s.rjust(8, '0')
    ].join('-')
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
