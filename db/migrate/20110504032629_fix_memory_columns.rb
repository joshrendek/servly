class FixMemoryColumns < ActiveRecord::Migration
  def self.up
    remove_column :collective_stats, :memory_free 
    remove_column :collective_stats, :memory_used
    remove_column :servers, :mem_free
    remove_column :servers, :mem_used
    remove_column :servers, :swap_free
    remove_column :servers, :swap_used

    add_column :collective_stats, :memory_free, :float 
    add_column :collective_stats, :memory_used, :float
    add_column :servers, :mem_free, :float
    add_column :servers, :mem_used, :float
    add_column :servers, :swap_free, :float
    add_column :servers, :swap_used, :float
  end

  def self.down
  end
end
