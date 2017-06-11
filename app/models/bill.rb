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


  belongs_to :client
  belongs_to :historial

  has_many :bill_items

  def self.send_milonga(attrs)
    data = { pkey: './NUEVA-optica-private.key', cert: './NUEVO-optica.crt', cuit: '27125786524', sale_point: '0004', own_iva_cond: :responsable_inscripto }
    bill = Snoopy::Bill.new(data.merge(attrs))
    bill.cae_request
    bill
  end

  def self.build_from_historial
    h = self.historial
    bill = new(
      client_id: h.cliente_id,
      historical_id: h.id,
      amount: h.precio
    )
    bill.bill_items.build(
      description: h.description,
      amount: h.precio
    )
    bill
  end

  def data_for_afip
    data = {}
    data[:doc_num] = self.client.document_number
    data[:documento] = self.client.document_type
    data[:iva_cond] = BILL_TYPES[self.client.bill_type]
    # Opcional
    #data[:fch_serv_desde] = data[:fch_serv_hasta] = Date.today.strftime('%Y%m%d')

    data[:imp_iva] = (self.amount/1.21).round(2)
    data[:alicivas] = [
      {
        id: 0.21,  importe: self.amount,  base_imp: data[:imp_iva]
      }
    ]
    data[:net] = self.amount
    data[:net] -= data[:imp_iva] if self.client.bill_type == 'A'
  end
end
