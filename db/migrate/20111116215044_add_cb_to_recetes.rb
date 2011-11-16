class AddCbToRecetes < ActiveRecord::Migration
  def change
    add_column :recetes, :cb, :string
  end
end
