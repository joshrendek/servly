class IndexesToLogs < ActiveRecord::Migration
  def self.up
    add_index :logs, :server_id
    add_index :logs, :created_at
  end

  def self.down
  end
end
