class CreateCollectiveStats < ActiveRecord::Migration
  def self.up
    create_table :collective_stats do |t|
      t.integer :domain_id
      t.integer :net_in
      t.integer :net_out
      t.integer :net_total
      t.float :cpu_usage
      t.integer :number_of_cpus
      t.integer :memory_free
      t.integer :memory_used
      t.integer :net_connections

      t.timestamps
    end
  end

  def self.down
    drop_table :collective_stats
  end
end
