class ChangeUrlMonitorLogs < ActiveRecord::Migration
  def self.up
    remove_column :url_monitor_logs, :status_code 
    add_column :url_monitor_logs, :status_code, :integer
  end

  def self.down
  end
end
