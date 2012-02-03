class AddFacturaToHistorial < ActiveRecord::Migration
  def change
    add_column :historials, :factura, :string
  end
end
