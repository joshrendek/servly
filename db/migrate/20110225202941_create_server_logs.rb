class CreateServerLogs < ActiveRecord::Migration
  def self.up
    create_table :server_logs do |t|
      t.integer :group_id
      t.integer :domain_id
      t.string :hostname
      t.string :ip
      t.string :location
      t.float :cpu_usage
      t.integer :disk_size
      t.integer :disk_used
      t.float :load_one
      t.float :load_five
      t.float :load_fifteen
      t.integer :mem_free
      t.integer :mem_used
      t.integer :swap_free
      t.integer :swap_used
      t.integer :net_in
      t.integer :net_out
      t.integer :running_procs
      t.integer :number_of_cpus
      t.string :kernel
      t.string :release
      t.integer :pending_updates

      t.timestamps
    end
  end

  def self.down
    drop_table :server_logs
  end
end
