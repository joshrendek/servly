class AddTargetableToAlerts < ActiveRecord::Migration
  def self.up
    add_column :alerts, :targetable_id, :integer
    add_column :alerts, :targetable_type, :string
  end

  def self.down
    remove_column :alerts, :targetable_type
    remove_column :alerts, :targetable_id
  end
end
