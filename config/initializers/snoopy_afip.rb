if Rails.env.production?
  Snoopy.auth_url    = "https://wsaa.afip.gov.ar/ws/services/LoginCms"
  Snoopy.service_url =  './prod.wsdl'
else
  Snoopy.auth_url    = "https://wsaahomo.afip.gov.ar/ws/services/LoginCms"
  Snoopy.service_url =  './testing.wsdl'
end
Snoopy.default_moneda    = :peso
Snoopy.default_concepto  = 'Productos y Servicios'
Snoopy.default_documento = 'CUIT'
