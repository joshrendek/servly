class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :domain_id
      t.integer :server_id
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
