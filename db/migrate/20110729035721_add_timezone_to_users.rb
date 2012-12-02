class AddTimezoneToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :timezone, :string, :default => "Eastern Time (US & Canada)"
  end

  def self.down
    remove_column :users, :timezone
  end
end
