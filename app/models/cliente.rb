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

  def to_name
    [self.nombre, self.apellido].join(' ')
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
    t_year, t_month, t_day = Time.zone.now.to_date.to_s.split('-').map(&:to_i)
    Cliente.all.each do |cliente|
      c_year, c_month, c_day = cliente.nacimiento.to_s.split('-').map(&:to_i)

      if c_year != 1920 && c_month == t_month && c_day == t_day
        MyMailer.delay.feliz_cumple(cliente)
      end
    end
  end

  def self.cumple
    today = Time.zone.now
    yday  = today.yday
    in_a_week = yday + 7
    last_day = today.at_end_of_year.yday

    range = if in_a_week <= last_day
              (yday..in_a_week).to_a
            else
              rest_of_days = (in_a_week - last_day) - 1

              (yday..last_day).to_a + (1..rest_of_days).to_a
            end

    clients = where(
      'DAYOFYEAR(nacimiento) in (:days)', days: range
    ).where([
      'YEAR(nacimiento) != 1920',
      'DAYOFMONTH(nacimiento) = :day',
      'MONTH(nacimiento) = :month'
    ].join(' AND '), day: today.day, month: today.month)

    clients.sort_by {|c| c.nacimiento.yday }
  end
end
