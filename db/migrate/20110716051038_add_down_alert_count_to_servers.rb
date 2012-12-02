class AddDownAlertCountToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :down_alert_count, :integer, :default => 0
  end

  def self.down
    remove_column :servers, :down_alert_count
  end
end
