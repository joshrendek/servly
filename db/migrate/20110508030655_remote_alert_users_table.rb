class RemoteAlertUsersTable < ActiveRecord::Migration
  def self.up
    drop_table "alert_users"
  end

  def self.down
  end
end
