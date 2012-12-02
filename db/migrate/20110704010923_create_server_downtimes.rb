class CreateServerDowntimes < ActiveRecord::Migration
  def self.up
    create_table :server_downtimes do |t|
      t.integer :domain_id
      t.integer :server_id

      t.timestamps
    end
  end

  def self.down
    drop_table :server_downtimes
  end
end
