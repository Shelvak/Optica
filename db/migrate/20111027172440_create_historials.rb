class CreateHistorials < ActiveRecord::Migration
  def change
    create_table :historials do |t|
      t.boolean :tipolente, default: false
      t.string :lente
      t.string :colorlente
      t.string :armazon
      t.string :cristales
      t.text :observaciones
      t.text :uso
      t.text :seguimiento
      t.decimal :precio, precision: 15, scale: 2, default: 0.00
      t.integer :orden
      t.integer :cliente_id

      t.timestamps
    end
  end
end
