class AddCustomerToLogin < ActiveRecord::Migration[5.1]
  def change
    add_reference :logins, :customer, index: true
  end
end
