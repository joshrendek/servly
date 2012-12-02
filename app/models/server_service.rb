class ServerService < ActiveRecord::Base
  belongs_to :server
  belongs_to :service

  attr_accessible :domain_id, :server_id, :status, :service_id
end
