class MonitoredService < ActiveRecord::Base
  belongs_to :server
  belongs_to :service
  belongs_to :domain

  attr_accessible :domain_id, :server_id, :service_id, :service_status, :service_value
end
