class CreateCreditNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_notes do |t|
      t.integer :bill_id, null: false
      t.string :cae, null: false
      t.integer :number, null: false
      t.date :due_date
      t.json :request, default: {}
      t.json :response, default: {}

      t.timestamps
    end

    add_index :credit_notes, :bill_id
  end
end
