class CreateTriggeredAlerts < ActiveRecord::Migration
  def self.up
    create_table :triggered_alerts do |t|
      t.integer :domain_id
      t.string :triggerable_alert

      t.timestamps
    end
  end

  def self.down
    drop_table :triggered_alerts
  end
end
