class AddTerminatedToDomains < ActiveRecord::Migration
  def self.up
    add_column :domains, :terminated, :integer, :default => 0
  end

  def self.down
    remove_column :domains, :terminated
  end
end
