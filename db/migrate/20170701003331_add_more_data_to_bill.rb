class AddMoreDataToBill < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :client_vat_condition, :string
  end
end
