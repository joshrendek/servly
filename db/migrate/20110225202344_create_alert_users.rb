class CreateAlertUsers < ActiveRecord::Migration
  def self.up
    create_table :alert_users do |t|
      t.integer :user_id
      t.integer :alert_id

      t.timestamps
    end
  end

  def self.down
    drop_table :alert_users
  end
end
