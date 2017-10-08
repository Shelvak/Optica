class ChangeVentaColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :venta, :mes, :month
    rename_column :venta, :anio, :year

    rename_column :venta, :vendido, :others_amount
    rename_column :venta, :cantvendida, :others_quantity
    rename_column :venta, :cant_flotante, :floating_quantity
    rename_column :venta, :cant_contacto, :contact_quantity
    rename_column :venta, :venta_contacto, :contact_amount
    rename_column :venta, :venta_flotante, :floating_amount
  end
end
