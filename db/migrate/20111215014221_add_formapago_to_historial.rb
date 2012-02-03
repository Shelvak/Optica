class AddFormapagoToHistorial < ActiveRecord::Migration
  def change
    add_column :historials, :formapago, :string
  end
end
