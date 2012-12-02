class TeamUser < ActiveRecord::Base
  belongs_to :domain
  belongs_to :user
  belongs_to :team

  attr_accessible :user_id, :domain_id, :team_id
end
