class AddAlertIdToTriggeredAlerts < ActiveRecord::Migration
  def self.up
    add_column :triggered_alerts, :alert_id, :integer
    remove_column :triggered_alerts, :triggerable_alert
  end

  def self.down
    remove_column :triggered_alerts, :alert_id
  end
end
