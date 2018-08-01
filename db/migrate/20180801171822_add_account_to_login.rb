class AddAccountToLogin < ActiveRecord::Migration[5.1]
  def change
    add_reference :accounts, :login, index: true
  end
end
