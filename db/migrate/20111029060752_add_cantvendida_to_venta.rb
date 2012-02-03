class AddCantvendidaToVenta < ActiveRecord::Migration
  def change
    add_column :venta, :cantvendida, :integer, default: 0
  end
end
