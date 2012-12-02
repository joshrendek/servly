class Log < ActiveRecord::Base
  has_one :message
  belongs_to :domain
  belongs_to :server

  attr_accessible :domain_id, :server_id, :message_id
end
