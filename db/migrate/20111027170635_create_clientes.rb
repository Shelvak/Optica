class CreateClientes < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.string :nombre
      t.string :apellido
      t.integer :documento
      t.string :direccion
      t.integer :telefono
      t.string :celular
      t.string :email
      t.date :nacimiento
      t.string :ocupacion
      t.text :actividad

      t.timestamps
    end
  end
end
