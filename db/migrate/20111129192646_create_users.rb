class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.timestamps
    end
    add_index :users, :login, unique: true
  end
end
