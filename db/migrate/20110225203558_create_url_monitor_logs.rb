class CreateUrlMonitorLogs < ActiveRecord::Migration
  def self.up
    create_table :url_monitor_logs do |t|
      t.integer :domain_id
      t.float :response_time
      t.integer :status_code

      t.timestamps
    end
  end

  def self.down
    drop_table :url_monitor_logs
  end
end
