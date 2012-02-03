class AddLenteToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :lente, :string
  end
end
