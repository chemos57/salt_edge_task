class CreateLogins < ActiveRecord::Migration[5.1]
  def change
    create_table :logins do |t|
      t.string :log_id
      t.string :provider_name

      t.timestamps
    end
  end
end
