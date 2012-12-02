class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :subdomain
      t.string :domain
      t.integer :user_id
      t.string :api_key
      t.integer :server_limit
      t.integer :alert_limit
      t.integer :url_monitor_limit
      t.integer :user_limit
      t.integer :active

      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
