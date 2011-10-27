class AddRecomendadoToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :recomendado, :string
  end
end
