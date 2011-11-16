class AddTipoVentaToVenta < ActiveRecord::Migration
  def change
    add_column :venta, :tipo_venta, :string
  end
end
