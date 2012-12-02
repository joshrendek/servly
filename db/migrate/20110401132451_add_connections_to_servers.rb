class AddConnectionsToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :connections, :integer
  end

  def self.down
    remove_column :servers, :connections
  end
end
