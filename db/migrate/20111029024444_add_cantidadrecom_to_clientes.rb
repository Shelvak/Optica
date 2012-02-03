class AddCantidadrecomToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :cantidadrecom, :integer, default: 0
  end
end
