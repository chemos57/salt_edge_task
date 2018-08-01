class AddTransactionToAccount < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :account, index: true
  end
end
