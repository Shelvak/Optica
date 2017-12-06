class Bill < ActiveRecord::Base
  include PgSearch
  pg_search_scope :unicode_search,
                  against: [:number, :client_vat_condition],
                  ignoring: :accents,
                  using: { tsearch: { prefix: true } },
                  associated_against: {
                    client: [:nombre, :apellido]
                  }
  PAID_VIA = [
    'cash',
    'check',
    'credit_card',
    'debit_card'
  ]

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
  after_commit :assign_to_global_sales, on: :create

  belongs_to :client, class_name: Cliente
  belongs_to :historial
  has_one :credit_note

  has_many :bill_items

  accepts_nested_attributes_for :bill_items, reject_if: ->(attrs) {
    attrs['quantity'].to_i == 0 && attrs['amount'].to_f == 0.0
  }

  delegate :tipolente, to: :historial

  validates :paid_via, presence: true

  scope :between, ->(from, to) {
    where(created_at: from.beginning_of_day..to.end_of_day)
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

  def rollback
    cn = self.build_credit_note
    cn.authorize_against_afip!
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

    p "Autorizando con ", data
    bill = Snoopy::Bill.new(data)
    bill.cae_request
    if bill.aprobada?
      self.assign_from_afip_response(bill)
    else
      self.errors.add(:base, "Hubo un error")
      self.errors.add(:afip_error, bill.errors)
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
    (self.total_amount / 1.21).round(2)
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

  def to_accountant
    helper = ActionController::Base.helpers

    [
      self.created_at.strftime("%d-%m-%Y"),
      self.client.try(:id),
      self.client.try(:to_name),
      self.client.try(:vat_condition),
      self.client.try(:document_type),
      self.client.try(:document_number),
      "Fac #{self.bill_type}",
      self.number_with_sale_point,
      21,
      0,
      self.gross,
      self.vat_amount,
      self.total_amount
    ].join(',')
  end

  def assign_to_global_sales
    return if self.credit_note.present?

    venta = Venta.find_or_initialize_by(
      month: created_at.month, year: created_at.year
    )
    venta.increase_by_type(sell_type, self.total_amount)
    venta.save

    self.client.gastado += self.total_amount
    self.client.save
  end

  def sell_type
    self.historial.try(:sell_type) || :bill
  end

  def self.filtered_list(query)
    query.present? ? unicode_search(query) : all
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
