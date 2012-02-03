class AddDoctorToHistorials < ActiveRecord::Migration
  def change
    add_column :historials, :doctor, :string
  end
end
