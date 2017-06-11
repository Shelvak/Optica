class AddBillingInfoToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clientes, :document_number, :string, limit: 15
    add_column :clientes, :document_type, :string, limit: 5
    add_column :clientes, :bill_type, :string, limit: 1
  end
end
