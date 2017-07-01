class AddVatConditionToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clientes, :vat_condition, :string
  end
end
