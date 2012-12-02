class UrlMonitorLog < ActiveRecord::Base
  belongs_to :url_monitor
  belongs_to :domain


  attr_accessible :domain_id, :response_time, :current_status, :url_monitor_id
end
