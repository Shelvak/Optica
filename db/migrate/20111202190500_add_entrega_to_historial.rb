class AddEntregaToHistorial < ActiveRecord::Migration
  def change
    add_column :historials, :entrega, :date
  end
end
