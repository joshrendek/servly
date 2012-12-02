class CreateMonitoredServiceLogs < ActiveRecord::Migration
  def self.up
    create_table :monitored_service_logs do |t|
      t.integer :domain_id
      t.integer :server_id
      t.integer :service_id
      t.integer :service_status
      t.string :service_value

      t.timestamps
    end
  end

  def self.down
    drop_table :monitored_service_logs
  end
end
