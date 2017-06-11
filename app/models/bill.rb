class Bill < ActiveRecord::Base
  require 'snoopy_afip'
  Snoopy.auth_url    = "https://wsaa.afip.gov.ar/ws/services/LoginCms"
  Snoopy.service_url =  './prod.wsdl' #lib_path + '/files/prod.wsdl'
  Snoopy.default_moneda    = :peso
  Snoopy.default_concepto  = 'Servicios'
  Snoopy.default_documento = 'CUIT'


  belongs_to :client
  belongs_to :historial

  has_many :bill_items

  data = {}
  data[:concepto] = 'Productos y Servicios'
  data[:imp_iva] = 0.21
  data[:alicivas] = [{id: 0.21,  importe: 1,  base_imp: 0.21}]
  data[:net] = 0.21
  data[:doc_num]  = '34675601'
  data[:documento] = 'DNI'
  data[:fch_serv_desde] = '20170610'
  data[:fch_serv_hasta] = '20170620'
  data[:iva_cond] = :factura_b
  def self.send_milonga(attrs)
    data = { pkey: './NUEVA-optica-private.key', cert: './NUEVO-optica.crt', cuit: '27125786524', sale_point: '0004', own_iva_cond: :responsable_inscripto }
    bill = Snoopy::Bill.new(data.merge(attrs))
    bill.cae_request
    bill
  end
end
