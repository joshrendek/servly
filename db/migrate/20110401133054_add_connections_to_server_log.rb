class AddConnectionsToServerLog < ActiveRecord::Migration
  def self.up
    add_column :server_logs, :connections, :integer
    add_column :server_logs, :os, :string
  end

  def self.down
    remove_column :server_logs, :os
    remove_column :server_logs, :connections
  end
end
