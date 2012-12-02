class CreateServerServices < ActiveRecord::Migration
  def self.up
    create_table :server_services do |t|
      t.integer :server_id
      t.integer :domain_id
      t.integer :service_id
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :server_services
  end
end
