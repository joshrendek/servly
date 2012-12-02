class AddOrderToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :setting_ord, :integer
  end

  def self.down
    remove_column :settings, :setting_ord
  end
end
