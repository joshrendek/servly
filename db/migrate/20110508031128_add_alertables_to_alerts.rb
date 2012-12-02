class AddAlertablesToAlerts < ActiveRecord::Migration
  def self.up
    add_column :alerts, :alertable_id, :integer
    add_column :alerts, :alertable_type, :string
  end

  def self.down
    remove_column :alerts, :alertable_type
    remove_column :alerts, :alertable_id
  end
end
