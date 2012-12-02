class AddUrlMonitorIdToUrlMonitorLogs < ActiveRecord::Migration
  def self.up
    add_column :url_monitor_logs, :url_monitor_id, :integer
  end

  def self.down
    remove_column :url_monitor_logs, :url_monitor_id
  end
end
