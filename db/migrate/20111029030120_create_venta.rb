class CreateVenta < ActiveRecord::Migration
  def change
    create_table :venta do |t|
      t.integer :mes
      t.integer :anio
      t.decimal :vendido, precision: 15, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
