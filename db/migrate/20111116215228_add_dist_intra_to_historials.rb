class AddDistIntraToHistorials < ActiveRecord::Migration
  def change
    add_column :historials, :dist_intra, :string
  end
end
