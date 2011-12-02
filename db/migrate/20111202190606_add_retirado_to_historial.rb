class AddRetiradoToHistorial < ActiveRecord::Migration
  def change
    add_column :historials, :retirado, :boolean, default: false
  end
end
