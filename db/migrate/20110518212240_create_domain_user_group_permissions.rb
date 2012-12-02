class CreateDomainUserGroupPermissions < ActiveRecord::Migration
  def self.up
    create_table :domain_user_group_permissions do |t|
      t.integer :domain_user_id
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :domain_user_group_permissions
  end
end
