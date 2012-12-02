class DomainUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :domain
  has_many :domain_user_group_permissions

  attr_accessible :user_id, :domain_id, :active, :alerts, :triggered_alert_id
end
