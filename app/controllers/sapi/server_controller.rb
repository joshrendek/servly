class Sapi::ServerController < ApplicationController
  skip_before_filter :authenticate_user!, :verify_domain_user, :check_server_num
  skip_before_filter :restricted_to_groups
  before_filter :authorize
  def index
    @domain = Domain.find_by_subdomain(params[:subdomain])
    @tmp = []
    @domain.servers.each do |s|
      s.updated_at > DateTime.now.advance(:minutes => -5) ? alive = 1 : alive = 0
      s['alive'] = alive
      @tmp << s
    end
    render :json => @tmp
  end
end
