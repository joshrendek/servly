class AddDomainIdToDomainUserGroupPermissions < ActiveRecord::Migration
  def self.up
    add_column :domain_user_group_permissions, :domain_id, :integer
  end

  def self.down
    remove_column :domain_user_group_permissions, :domain_id
  end
end
