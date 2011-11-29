class AddAuthenticToUsers < ActiveRecord::Migration
  def change
    add_column :users, :crypted_password, :string, unique: true
    add_column :users, :password_salt, :string
    add_column :users, :persistence_token, :string, unique: true
  end
end
