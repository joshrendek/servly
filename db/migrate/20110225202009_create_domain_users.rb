class CreateDomainUsers < ActiveRecord::Migration
  def self.up
    create_table :domain_users do |t|
      t.integer :user_id
      t.integer :domain_id
      t.integer :active

      t.timestamps
    end
  end

  def self.down
    drop_table :domain_users
  end
end
