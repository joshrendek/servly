class ApiController < ApplicationController
  before_filter :verify_key
  skip_before_filter :authenticate_user!, :check_permissions, :check_active_domain
  skip_before_filter :verify_domain_user
  skip_before_filter :check_server_num
  skip_before_filter :restricted_to_groups

  skip_before_filter :verify_authenticity_token
  skip_before_filter :verify_active


  def index
      render :text => "Index", :status => 200
  end

  def terminate
      @d = Domain.find(:first, :conditions => ["subdomain = ?", params[:subdomain]])
      @d.terminated = 1
      @d.save
      render :text => "Domain marked terminated.", :status => 200
  end

  def suspend_domain
      @d = Domain.find(:first, :conditions => ["subdomain = ?", params[:subdomain]])
      @d.active = 0
      @d.save
      render :text => "Domain suspended #{@d.subdomain}", :status => 200
  end
  
  def login_as
    @user = User.find(:first, :conditions => ["login = ?", params[:name]])
    self.current_user = @user
    redirect_to  '/'
  end

  def get_usage
    @user = User.find(:first, :conditions => ["login = ?", params[:name]])
    @d = Domain.find(:first, :conditions => ["user_id = ? AND domain = ?", @user.id, params[:subdomain]])
    curr = Server.find(:all, :conditions => ["subdomain = ?", @d.id]).count

    render :text => curr.to_s
  end
  
  def limits_user
      @user = User.find(:first, :conditions => ["login = ?", params[:name]])
      @d = Domain.find(:first, :conditions => ["user_id = ? AND domain = ?", @user.id, params[:subdomain]])
      @d.quantity = params[:quantity] 
      @d.save
      render :text => "Updated domain quantity."
  end
  
  def change_password
      @user = User.find(:first, :conditions => ["email = ?", params[:email]])
      if @user.nil? then
        render :text => 'FAIL: No such username'
      else
        @user.password = params[:pass]
        @user.password_confirmation = params[:pass]
        if @user.save then
          render :text => 'Success: changed user password'
        else
          render :text => 'FAIL: Unexpected; unable to save user -- Error count=' + @user.errors.count.to_s + ', errors=' + @user.errors.full_messages.join(', '), :status => 500
        end
      end
  end
  
  def add_user
    @user = User.create(:email => params[:email], :password => params[:password], :password_confirmation => params[:password])
    success = @user && @user.save
    @user.save
    
    if success && @user.errors.empty?
        domain = params[:subdomain]
        subdomain = domain

        @d = Domain.create(:subdomain => params[:subdomain], :user_id => @user.id, 
                           :server_limit => params[:server_limit],
                           :alert_limit => params[:alert_limit], 
                           :url_monitor_limit => params[:url_limit],
                           :user_limit => params[:user_limit],
                           :active => 1)
        
    
        @du = DomainUser.create(:user_id => @user.id, :domain_id => @d.id, :active => 1)
        worked = @d.save && @d && @du.save && @d
        if worked && @d.errors.empty? && @du.errors.empty?
            render :text => "User account created.", :status => 200
        else
            User.destroy(@user.id)
            @d.destroy
            @du.destroy
            
            errors =  ""
            @d.errors.each_full { |msg| errors << msg << "\n" }
            @du.errors.each_full { |msg| errors << msg << "\n" }

            render :text => errors, :status => 500
        end

    else
       errors =  ""
       @user.errors.each_full { |msg| errors << msg << "\n" }
       
       render :text => errors, :status => 500
    end
  end
  
  private
  def verify_key
     if params[:key].nil? or params[:key] != CONTROL_API_SECRET_KEY then
       render :text => 'FAIL: access denied; api key invalid', :status => :forbidden
       # Do not allow the request to proceed
       return false
     end
  end

end
