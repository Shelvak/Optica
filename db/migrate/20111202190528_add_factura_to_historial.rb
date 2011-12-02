class AddFacturaToHistorial < ActiveRecord::Migration
  def change
    add_column :historials, :factura, :integer
  end
end
