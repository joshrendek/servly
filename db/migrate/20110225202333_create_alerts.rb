class CreateAlerts < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.integer :domain_id
      t.string :threshold_stat
      t.integer :threshold_value

      t.timestamps
    end
  end

  def self.down
    drop_table :alerts
  end
end
