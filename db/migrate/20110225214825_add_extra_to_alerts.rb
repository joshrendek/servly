class AddExtraToAlerts < ActiveRecord::Migration
  def self.up
    add_column :alerts, :active, :integer
    add_column :alerts, :threshold_time, :integer
  end

  def self.down
    remove_column :alerts, :threshold_time
    remove_column :alerts, :active
  end
end
