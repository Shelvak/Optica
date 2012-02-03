class ChangeDistanciaToRecetes < ActiveRecord::Migration
  def change
    change_column :recetes, :distancia, :string
  end
end
