class Domain < ActiveRecord::Base
  has_many :servers
  has_many :users, :through => :domain_users
  has_many :alerts
  has_many :url_monitors
  has_many :collective_stats
  has_many :automated_tasks
  has_many :triggered_alerts
  has_many :server_services
  has_many :services
  has_many :domain_users
  has_many :groups
  has_many :teams
  has_many :server_downtimes
  has_many :group_servers

  attr_accessible :subdomain, :domain, :user_id, :api_key, :server_limit, :alert_limit, :url_monitor_limit, :user_limit,
                  :active, :terminated

  after_create :create_services, :generate_api_key

  def uptime(months = 1)
    total = months * 31 * 24 * 12 * 5
    100.0 - ((self.server_downtimes.where(:created_at => Time.now.advance(:months => -months)..Time.now).size.to_f)/total.to_f)  * 100.0
  end

  private

  def generate_api_key
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + (1..9).to_a*2
    rand_str = (0..64).collect { chars[Kernel.rand(chars.length)] }.join
    update_attributes(:api_key => rand_str)
  end
  
  def create_services
    #p id
    #p self.id

    Service.create(:service_name => 'HTTP', :service_variable => 'http', :service_type => 'server', :domain_id => id)
    Service.create(:service_name => 'Database', :service_variable => 'db', :service_type => 'server', :domain_id => id)
    Service.create(:service_name => 'FTP', :service_variable => 'ftp', :service_type => 'server', :domain_id => id)
    Service.create(:service_name => 'SSH', :service_variable => 'ssh', :service_type => 'server', :domain_id => id)
    Service.create(:service_name => 'NFS', :service_variable => 'nfs', :service_type => 'server', :domain_id => id)
    Service.create(:service_name => 'DNS', :service_variable => 'dns', :service_type => 'server', :domain_id => id)
    Service.create(:service_name => 'Mail', :service_variable => 'mail', :service_type => 'server', :domain_id => id)

  end
end
