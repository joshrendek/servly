class AddAlertsToDomainUsers < ActiveRecord::Migration
  def self.up
    add_column :domain_users, :alerts, :boolean, :default => true
  end

  def self.down
    remove_column :domain_users, :alerts
  end
end
