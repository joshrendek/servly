class AddTimesToAlerts < ActiveRecord::Migration
  def self.up
    add_column :alerts, :start_time, :time
    add_column :alerts, :end_time, :time
  end

  def self.down
    remove_column :alerts, :end_time
    remove_column :alerts, :start_time
  end
end
