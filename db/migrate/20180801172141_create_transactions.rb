class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :tr_id
      t.string :mode
      t.string :status
      t.string :amount
      t.string :curr_code
      t.string :description

      t.timestamps
    end
  end
end
