class AddTriggerableToTriggeredAlerts < ActiveRecord::Migration
  def self.up
    add_column :triggered_alerts, :triggerable_type, :string
    add_column :triggered_alerts, :triggerable_id, :integer
  end

  def self.down
    remove_column :triggered_alerts, :triggerable_id
    remove_column :triggered_alerts, :triggerable_type
  end
end
