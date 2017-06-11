class CreateBillItems < ActiveRecord::Migration[5.0]
  def change
    create_table :bill_items do |t|
      t.integer :bill_id, null: false, index: true
      t.string :description, null: false
      t.decimal :amount, null: false

      t.datetime :created_at
    end
  end
end
