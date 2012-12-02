class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.integer :group_id
      t.integer :domain_id
      t.string :hostname
      t.string :ip
      t.string :location
      t.float :cpu_usage
      t.float :disk_size
      t.float :disk_used
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
      t.text :running_process
      t.integer :pending_updates

      t.timestamps
    end
  end

  def self.down
    drop_table :servers
  end
end
