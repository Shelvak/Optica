class Cliente < ActiveRecord::Base
 
  
  before_save :camel, :asignar_cantidadrecom
  before_validation :asignar_recomendado, :verificar_documento
  has_many :historials
  
  
  attr_accessor :auto_recomendado
  
  
  scope :buscar, lambda { |nombre| where("LOWER(nombre)LIKE ? OR LOWER(apellido) LIKE ? OR documento LIKE ?",
      "#{nombre}%".downcase, "#{nombre}%".downcase, "#{nombre}%")}

  
  validates :nombre, :apellido, :documento, presence: true
  validates :documento, uniqueness: true, presence: true
  
  
  def self.search(search)
     if search
      where('LOWER(nombre) || LOWER(apellido) || documento LIKE ?', "%#{search}%".downcase)
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
      @cli = Cliente.all
      @cli.each_with_index do |clien, i|
        @clien = clien
        mes = @clien.nacimiento.month.to_i
        dia = @clien.nacimiento.day.to_i
        if mes == Date.today.month.to_i
          if (dia >= Date.today.day.to_i && dia <= 7.days.from_now.day.to_i) || (dia >= 23 && mes == (Date.today.month.to_i + 1))
            (@cumples = Array.new ) if i == 1
            @cumples << @clien 
          end
        end
      end
   @cumples.sort! { |a, b|  a.nacimiento.day <=> b.nacimiento.day } if @cumples  
  end
  
end
