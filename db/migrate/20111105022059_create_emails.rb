class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :to
      t.text :cuerpo

      t.timestamps
    end
  end
end
