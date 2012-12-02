class AddUptimeToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :uptime, :string
  end

  def self.down
    remove_column :servers, :uptime
  end
end
