class Team < ActiveRecord::Base
  has_many :users, :through => :team_users
  has_many :team_users
  belongs_to :domain

  attr_accessible :name, :domain_id
end
