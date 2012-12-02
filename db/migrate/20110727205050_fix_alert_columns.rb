class FixAlertColumns < ActiveRecord::Migration
  def self.up
    remove_column :alerts, :threshold_value
    add_column :alerts, :threshold_value, :float
  end

  def self.down
  end
end
