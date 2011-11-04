class CreateRecetes < ActiveRecord::Migration
  def change
    create_table :recetes do |t|
      t.boolean :ojo, default: true
      t.decimal :esferico, default: 0.0
      t.decimal :cilindrico, default: 0.0
      t.decimal :eje, default: 0.0
      t.decimal :diametro, default: 0.0
      t.decimal :adicion, default: 0.0
      t.string :av
      t.boolean :distancia, default: false
      t.boolean :receta, default: true
      t.integer :historial_id

      t.timestamps
    end
  end
end
