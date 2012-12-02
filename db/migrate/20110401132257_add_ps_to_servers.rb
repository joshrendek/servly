class AddPsToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :ps, :string
  end

  def self.down
    remove_column :servers, :ps
  end
end
