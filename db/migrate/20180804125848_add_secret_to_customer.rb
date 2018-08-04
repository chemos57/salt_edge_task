class AddSecretToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :secret, :string
  end
end
