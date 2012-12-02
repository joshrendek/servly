class Api::ServersController < ApplicationController
  before_filter :verify_key
  skip_before_filter :authenticate_user!, :check_permissions, :check_active_domain
  skip_before_filter :verify_domain_user
  skip_before_filter :check_server_num
  skip_before_filter :restricted_to_groups

  skip_before_filter :verify_authenticity_token
  skip_before_filter :verify_active

  def index
    render :json => subdomain.servers
  end

  def show
    tmp = subdomain.servers.find(params[:id])
    beginning = Time.now.advance(:hours => -(params[:hours].to_i || 24))
    tmp["history"] = tmp.server_logs.where("created_at > ?", beginning)
    render :json => tmp
  end

  private
  def verify_key
    if params[:key].nil? or params[:key] != subdomain.api_key then
      render :json => {"error" => 'access denied; api key invalid'}, :status => :forbidden
        # Do not allow the request to proceed
      return false
    end
  end


end
