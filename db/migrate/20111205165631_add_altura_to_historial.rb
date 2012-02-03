class AddAlturaToHistorial < ActiveRecord::Migration
  def change
    add_column :historials, :altura, :string
  end
end
