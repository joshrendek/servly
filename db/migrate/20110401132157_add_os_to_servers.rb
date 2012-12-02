class AddOsToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :os, :string
  end

  def self.down
    remove_column :servers, :os
  end
end
