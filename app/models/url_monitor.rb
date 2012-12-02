class UrlMonitor < ActiveRecord::Base
  belongs_to :domain
  has_many :alerts
  has_many :url_monitor_logs
  after_create :verify_http
  after_update :verify_http

  attr_accessible :url, :response_time, :status_code, :keyword, :current_run, :current_status



  def verify_http
    turl = self.url
    if !turl.include?('http://')
      self.update_attributes(:url => "http://#{turl}")
    end
  end

  def graph_response_times(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.url_monitor_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| p s; arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, s.response_time*1000] }
    arr.to_s
  end

  def graph_status_codes(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.url_monitor_logs.where("created_at > ?", beginning).group(:current_status).select("current_status, count(current_status) AS status_size")
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << ["{ label: '#{s.current_status}', data: #{s.status_size} } "] }
    arr.join(',')
  end


  def run_monitor
  end

end
