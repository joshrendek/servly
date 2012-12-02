class AddLastTriggeredAlertIdToDomainUsers < ActiveRecord::Migration
  def self.up
    add_column :domain_users, :triggered_alert_id, :integer
  end

  def self.down
    remove_column :domain_users, :triggered_alert_id
  end
end
