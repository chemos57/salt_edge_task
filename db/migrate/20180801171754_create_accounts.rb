class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :acc_id
      t.string :a_name
      t.string :nature
      t.string :balance
      t.string :currency_code

      t.timestamps
    end
  end
end
