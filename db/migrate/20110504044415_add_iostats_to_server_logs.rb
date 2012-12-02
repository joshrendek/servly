class AddIostatsToServerLogs < ActiveRecord::Migration
  def self.up
    add_column :server_logs, :blk_reads, :float
    add_column :server_logs, :blk_writes, :float
  end

  def self.down
    remove_column :server_logs, :blk_writes
    remove_column :server_logs, :blk_reads
  end
end
