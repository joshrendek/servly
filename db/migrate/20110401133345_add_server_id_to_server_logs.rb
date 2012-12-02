class AddServerIdToServerLogs < ActiveRecord::Migration
  def self.up
    add_column :server_logs, :server_id, :integer
  end

  def self.down
    remove_column :server_logs, :server_id
  end
end
