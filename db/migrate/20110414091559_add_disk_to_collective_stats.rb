class AddDiskToCollectiveStats < ActiveRecord::Migration
  def self.up
    add_column :collective_stats, :disk_used, :float
    add_column :collective_stats, :disk_size, :float
  end

  def self.down
    remove_column :collective_stats, :disk_size
    remove_column :collective_stats, :disk_used
  end
end
