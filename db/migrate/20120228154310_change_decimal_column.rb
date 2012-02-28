class ChangeDecimalColumn < ActiveRecord::Migration
  def change
	change_column :recetes, :esferico, :decimal, precision: 15, scale: 2
	change_column :recetes, :cilindrico, :decimal, precision: 15, scale: 2
	change_column :recetes, :eje, :decimal, precision: 15, scale: 2
	change_column :recetes, :diametro, :decimal, precision: 15, scale: 2
	change_column :recetes, :adicion, :decimal, precision: 15, scale: 2
	change_column :venta, :venta_contacto, :decimal, precision: 15, scale: 2
	change_column :venta, :venta_flotante, :decimal, precision: 15, scale: 2
  end

end
