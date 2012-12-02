class Service < ActiveRecord::Base
  belongs_to :domain
  attr_accessible :service_name, :service_variable, :domain_id, :service_type
  has_many :server_services

  has_many :servers, :through => :server_services

  before_destroy :delete_server_services


  protected
  def delete_server_services
    self.server_services.find_each { |ss| ss.destroy }
  end
end
