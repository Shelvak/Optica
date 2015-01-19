class Cliente < ActiveRecord::Base


  before_save :camel, :asignar_cantidadrecom
  before_validation :asignar_recomendado, :verificar_documento
  has_many :historials


  attr_accessor :auto_recomendado


  scope :buscar, lambda { |nombre| where("LOWER(nombre)LIKE ? OR LOWER(apellido) LIKE ? OR documento LIKE ?",
      "#{nombre}%".downcase, "#{nombre}%".downcase, "#{nombre}%")}


  validates :nombre, :apellido, :documento, presence: true
  validates :documento, uniqueness: true
  validates :telefono, allow_nil: true, allow_blank: true, numericality: {
  only_integer: true, greater_than_or_equal_to: 0, less_than: 2147483648}



  def self.search(search)
     if search.present?
      where(["LOWER(#{table_name}.nombre) LIKE :q",
             "LOWER(#{table_name}.apellido) LIKE :q",
             "#{table_name}.documento LIKE :q"].join(' OR '),
              q: "%#{search}%".downcase)
    else
      scoped
    end
  end


  def camel
    self.nombre = self.nombre.split.map(&:camelize).join(' ')
    self.apellido = self.apellido.split.map(&:camelize).join(' ')
  end

  def to_s
		self.nombre + ' ' + self.apellido + ' ' + self.documento
	end

  def verificar_documento
    self.documento = self.documento.split('.').join
  end

  def asignar_recomendado
    if self.auto_recomendado.present?
      self.recomendado = self.auto_recomendado
    end
  end

  def asignar_cantidadrecom
    if self.auto_recomendado.present?
      @cliente = Cliente.find_by_documento(self.auto_recomendado.split(' ').last)
      @cliente.cantidadrecom += 1
      @cliente.update_attributes(cantidadrecom: @cliente.cantidadrecom)
    end
  end

  def self.happyverde
    @clientes = Cliente.all
    @clientes.each do |clien|
      @cliente = clien
      mes = @cliente.nacimiento.month.to_i
      dia = @cliente.nacimiento.day.to_i
        MyMailer.feliz_cumple(clien).deliver if (mes == Date.today.month && dia == Date.today.day)
    end
  end

  def self.cumple
    clients    = []
    today      = Date.today
    next_week  = 7.days.from_now.to_date
    today_year = today.year
    next_year  = today_year + 1

    all.each do |client|
      mes  = client.nacimiento.month
      dia  = client.nacimiento.day
      year = mes == 12 && dia >= 24 ? today_year : next_year
      date = Date.new(year, mes, dia)

      clients << client if date >= today && date <= next_week
    end

    clients.sort do |a,b|
      a_date = a.nacimiento
      b_date = b.nacimiento
      a_year = a_date.month == 12 && a_date.day >= 24 ? today_year : next_year
      b_year = b_date.month == 12 && b_date.day >= 24 ? today_year : next_year

      [a_year, a_date.month, a_date.day] <=> [b_year, b_date.month, b_date.day]
    end
  end
end
