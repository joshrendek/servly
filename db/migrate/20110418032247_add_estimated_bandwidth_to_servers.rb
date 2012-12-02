class AddEstimatedBandwidthToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :estimated_bandwidth, :float
  end

  def self.down
    remove_column :servers, :estimated_bandwidth
  end
end
