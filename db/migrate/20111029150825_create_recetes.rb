class CreateRecetes < ActiveRecord::Migration
  def change
    create_table :recetes do |t|
      t.boolean :ojo
      t.decimal :esferico
      t.decimal :cilindrico
      t.decimal :eje
      t.decimal :diametro
      t.decimal :adicion
      t.string :av
      t.boolean :distancia
      t.boolean :receta
      t.integer :historial_id

      t.timestamps
    end
  end
end
