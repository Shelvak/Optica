class AddGastadoToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :gastado, :decimal, precision: 15, scale: 2, default: 0.0
  end
end
