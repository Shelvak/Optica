class AddQuantityToBillItems < ActiveRecord::Migration[5.0]
  def change
    add_column :bill_items, :quantity, :integer, default: 1
  end
end
