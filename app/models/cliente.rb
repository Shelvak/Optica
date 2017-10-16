class Cliente < ActiveRecord::Base
  include PgSearch
  pg_search_scope :unicode_search,
                  against: [:nombre, :apellido, :documento],
                  ignoring: :accents,
                  using: { tsearch: { prefix: true } }

  before_save :camel, :asignar_cantidadrecom
  before_validation :verificar_documento
  has_many :historials
  has_many :bills, foreign_key: :client_id

  attr_accessor :auto_recomendado

  scope :with_email, -> { where("email IS NOT NULL or email != ''") }


  validates :nombre, :apellido, :documento, presence: true
  validates :documento, uniqueness: true
  validates :telefono, allow_nil: true, allow_blank: true, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than: 2147483648
  }

  def self.filtered_list(query)
    query.present? ? unicode_search(query) : all
  end

  def camel
    self.nombre = self.nombre.split.map(&:camelize).join(' ')
    self.apellido = self.apellido.split.map(&:camelize).join(' ')
  end

  def to_s
    [self.nombre, self.apellido, self.documento].join(' ')
  end

  def to_name
    I18n.transliterate [self.nombre, self.apellido].join(' ')
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
    #t_year, t_month, t_day = Time.zone.now.to_date.to_s.split('-').map(&:to_i)
    #Cliente.with_email.each do |cliente|
    #  c_year, c_month, c_day = cliente.nacimiento.to_s.split('-').map(&:to_i)

    #  if c_year != 1920 && c_month == t_month && c_day == t_day
    #    MyMailer.delay.feliz_cumple(cliente.id)
    #  end
    #end
  end

  def self.week_birthdays
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

    clients = where([
      'nacimiento IS NOT NULL',
      'EXTRACT(YEAR FROM nacimiento::timestamp) != 1920'
    ].join(' AND ')).where([
      'EXTRACT(DOY FROM nacimiento::timestamp) in (:days) OR',
      'EXTRACT(DAY FROM nacimiento::timestamp) = :day AND',
      'EXTRACT(MONTH FROM nacimiento::timestamp) = :month'
    ].join(' '), day: today.day, month: today.month, days: range).order(
      'EXTRACT(DOY FROM nacimiento::timestamp)',
    ).limit(
      20
      # ::Kaminari.config[:default_per_page]
    )

    clients.sort_by do |c|
      _order = c.nacimiento.yday
      c.nacimiento.leap? ? (_order - 1) : _order
    end
  end

  def billing_info_incomplete?
    self.document_number.blank? || self.document_type.blank? ||
      self.bill_type.blank? || self.vat_condition.blank?
  end

  def document_type_and_number
    [document_type, document_number].join(': ').upcase
  end

  def address
    direccion
  end
end
