class AddVariosToVenta < ActiveRecord::Migration
  def change
    add_column :venta, :cant_contacto, :integer, default: 0
    add_column :venta, :cant_flotante, :integer, default: 0
    add_column :venta, :venta_contacto, :decimal, default: 0.0
    add_column :venta, :venta_flotante, :decimal, default: 0.0
  end
end
