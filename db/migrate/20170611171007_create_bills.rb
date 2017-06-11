class CreateBills < ActiveRecord::Migration[5.0]
  def change
    create_table :bills do |t|
      t.integer :client_id, null: false, index: true
      t.integer :historial_id, index: true
      t.integer :number, null: false
      t.string :cae, null: false
      t.string :sale_point
      t.date :billed_date
      t.date :cae_due_date
      t.json :afip_response
      t.decimal :amount, precision: 15, scale: 2
      t.decimal :vat_amount, precision: 15, scale: 2
      t.decimal :vat, precision: 5, scale: 2
      t.string :bill_type

      t.timestamps
    end
  end
end
