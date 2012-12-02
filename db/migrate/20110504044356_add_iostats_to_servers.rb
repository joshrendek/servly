class AddIostatsToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :blk_reads, :float
    add_column :servers, :blk_writes, :float
  end

  def self.down
    remove_column :servers, :blk_writes
    remove_column :servers, :blk_reads
  end
end
