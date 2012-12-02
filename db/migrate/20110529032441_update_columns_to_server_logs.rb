class UpdateColumnsToServerLogs < ActiveRecord::Migration
  def self.up
    remove_column :server_logs, :mem_free
    remove_column :server_logs, :mem_used
    remove_column :server_logs, :swap_free
    remove_column :server_logs, :swap_used
    remove_column :server_logs, :disk_size
    remove_column :server_logs, :disk_used
    
    add_column :server_logs, :mem_free, :float
    add_column :server_logs, :mem_used, :float
    add_column :server_logs, :swap_free, :float
    add_column :server_logs, :swap_used, :float
    add_column :server_logs, :disk_size, :float
    add_column :server_logs, :disk_used, :float
  end

  def self.down
  end
end
