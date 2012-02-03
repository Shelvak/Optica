class AddQueraToRecetes < ActiveRecord::Migration
  def change
    add_column :recetes, :quera, :string
  end
end
