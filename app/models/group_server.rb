class GroupServer < ActiveRecord::Base
  belongs_to :domain
  belongs_to :server
  belongs_to :group

  attr_accessible :server_id, :domain_id, :group_id
end
