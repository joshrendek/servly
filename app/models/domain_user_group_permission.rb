class DomainUserGroupPermission < ActiveRecord::Base
  belongs_to :domain
  belongs_to :domain_user
  belongs_to :group

  attr_accessible :domain_user_id, :group_id, :domain_id
end
