class AddPaidViaToBill < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :paid_via, :string, limit: '20'
  end
end
