class AddOperatorToAlerts < ActiveRecord::Migration
  def self.up
    add_column :alerts, :operator, :string
  end

  def self.down
    remove_column :alerts, :operator
  end
end
