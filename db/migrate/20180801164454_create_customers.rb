class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :cust_id
      t.string :identifier

      t.timestamps
    end
  end
end
