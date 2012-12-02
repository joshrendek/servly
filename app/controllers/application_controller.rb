class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all # include all helpers, all the time

  before_filter :authenticate_user!
  before_filter :verify_domain_user
  before_filter :check_server_num
  before_filter :set_locale
  before_filter :restricted_to_groups
  before_filter :verify_active
  before_filter :set_timezone

  CONTROL_API_SECRET_KEY = "CqICmQ9qw7sCKfNDsQIrcnqxMiGecqv"

  include UrlHelper
  include SubdomainHelper
  before_filter :set_mailer_url_options

  def set_timezone
    # current_user.time_zone #=> 'Central Time (US & Canada)'
    if current_user.nil?
      Time.zone = 'Eastern Time (US & Canada)'
    else
      Time.zone = current_user.timezone || 'Eastern Time (US & Canada)'
    end
  end


  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = "en"
  end

  def verify_active
    if subdomain.active == 0
      redirect_to destroy_user_session_path, :warning => "This domain is no longer active."
    end
  end

  def user_is_restricted_to_these_groups
    x = nil
    if subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.size == 0
      x = 0
    else
      y = subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.collect { |g| g.group.id }
      x = []
      x = Group.find(y)
    end
    x
  end

  def restricted_to_groups
    x = subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions
    if x.size > 0
      redirect_to groups_path
    end
  end

  def check_server_num
    redirect_to agent_index_path, :notice => "You must add a server" if subdomain.servers.size == 0
  end

  def verify_domain_user
    u = subdomain.domain_users.where(:user_id => current_user.id)
    if u.first.nil? || u.first.active != 1
      subdomain.domain_users.create(:active => 0, :user_id => current_user.id) if subdomain.domain_users.where(:user_id => current_user.id).first.nil?
      redirect_to destroy_user_session_path, :error => "You dont have access to this domain -- your username has been added to the pending list and will be approved by an administrator."
    end
  end

  def check_active_domain
    if subdomain.subdomain != "api"
      d = subdomain
      if d.active == 0
        render :text => "Account not active.", :status => 403
      end
    end
  end

  def account_subdomain
    request.subdomains[0]
  end

  def account_domain
    begin
      request.subdomains.join('.') + "." + request.domain
    rescue TypeError # nil subdomains
      request.domain
    end
  end

  def subdomain_id
    begin
      Domain.find(:first, :conditions => ["subdomain = ? OR domain = ?", account_subdomain, account_domain]).id
    rescue RuntimeError
      return "Domain not found #{account_subdomain}"
    end
  end

  def subdomain
    begin
      Domain.find(:first, :conditions => ["subdomain = ? OR domain = ?", account_subdomain, account_domain])
    rescue RuntimeError
      return "Domain not found #{account_subdomain}"
    end
  end

  def at_limit
    curr = Server.find(:all, :conditions => ["subdomain = ?", subdomain_id]).count
    total = Domain.find(:first, :conditions => ["domain = ?", account_subdomain]).quantity

      #curr >= total ? true : false
    false
  end

              # check their domain key is correct
  def verify_key
    begin
      @domain_key = subdomain.api_key
    rescue

    end
    if params[:key] == @domain_key
      return true
    else
      render :text => "Forbidden", :status => 403
      return false
    end
  end

    # check to see if a user owns this server
  def ownership_required
    begin
      @server = Server.find(params[:server_id]||params[:id], :conditions => ["domain_id = ?", subdomain_id])
    rescue
      flash[:message] = "No server exists with that ID"
      render :text => 'Forbidden.'
    end
  end

  def url_ownership_required
    begin
      @server = UrlMonitor.find(params[:id], :conditions => ["subdomain_id = ?", subdomain_id])
    rescue
      flash[:message] = "No url monitor exists with that ID"
      redirect_to '/dashboard'
    end
  end

    # check if theyre signing up
  def check_signup
    if account_subdomain=='signup'
      redirect_to '/signup'
    end
  end

    ##
  def check_user_manager
    us = User.find(current_user.id)
    if us.role_id != 0
      flash[:warning] = "You dont have permission to access this."
      redirect_to dashboard_url
      return false
    end
  end

    ## check a users domain relationship
    ## check if a user is the master as well
  def check_domain_rel

    u = DomainUser.find(params[:id])
    us = User.find(u.user_id)
    if u.domain != subdomain_id && us.role_id != 0
      flash[:warning] = "You dont own that user and/or don't have permission to do this."
      redirect_to manage_users_url
      return false
    end
  end

    # * check a users permissions
    # * check if they belong to the domain theyre trying to access as well
  def check_permissions
    column_to_check = controller_name() + "_" + action_name
    user = User.find(current_user.id)

      # check domain before doing role checking
    subdomain = user.domain_users.collect { |d| d.domain }

    activated = false
    user.domain_users.collect { |d|
      if d.domain == subdomain_id && d.active == 1
        activated = true
      end
    }

    if !subdomain.include?(subdomain_id) || !activated
      redirect_to "/logout?belong=0"
      return false
    end

  end


    # FOR MOBILE SAPI
  def authorize
    require 'bcrypt'

    begin
      u = User.find_by_email(params[:username])
      d = Domain.find_by_subdomain(params[:subdomain])
      return u.valid_password?(params[:password]) && !d.domain_users.where(:user_id => u.id).nil?
    rescue
      return false
    end
  end

end
