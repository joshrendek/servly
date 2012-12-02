class CreateGroupServers < ActiveRecord::Migration
  def self.up
    create_table :group_servers do |t|
      t.integer :server_id
      t.integer :domain_id
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_servers
  end
end
