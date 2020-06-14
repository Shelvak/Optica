class AddGlassDistanceToClientes < ActiveRecord::Migration[5.0]
  def change
    add_column :clientes, :glass_distance, :string
    add_index :clientes, :glass_distance
    add_index :clientes, :lente
  end
end
