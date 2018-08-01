class AddUserToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_reference :customers, :user, index: true
  end
end
