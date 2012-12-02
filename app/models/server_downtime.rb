class ServerDowntime < ActiveRecord::Base
  belongs_to :server
  belongs_to :domain

  attr_accessible :domain_id, :server_id

end
