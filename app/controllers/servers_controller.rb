class ServersController < ApplicationController
  before_filter :ownership_required, :except => [:index, :new, :create, :healthy, :dead, :quick_search]

  skip_before_filter :restricted_to_groups, :only => [:show, :graphs, :uptime, :diagnostic_logs]

  before_filter :check_limits, :only => [:create, :new]

    #  Server.where("domain_id = ? AND updated_at > ?", subdomain_id, Time.now.advance(:minutes => -5))
  def healthy
    @servers = subdomain.servers.where('updated_at > ?', Time.now.advance(:minutes => -5))
    render :index
  end

  def uptime
    if user_is_restricted_to_these_groups != 0
      @group = subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.where(:group_id => params[:group_id]).first.group
      @server = @group.servers.find(params[:id])
    end

    if !params[:downview].nil?
      @downtimes = @server.server_downtimes.where(:created_at => Time.now.advance(:months => -1)..Time.now)
      logger.info "here"
    else
      @downtimes = @server.server_downtimes.where(:created_at => Time.now.advance(:months => -1)..Time.now)
    end
  end

  def graphs
    if user_is_restricted_to_these_groups == 0
      @server = subdomain.servers.find(params[:id])
    else
      @group = subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.where(:group_id => params[:group_id]).first.group
      @server = @group.servers.where(:id => params[:id]).first
    end
  end

  def dead
    @servers = subdomain.servers.where('updated_at < ?', Time.now.advance(:minutes => -5))
    render :index
  end

  def quick_search
    @s = subdomain.servers.where('hostname LIKE ?', "%"+params[:q]+"%")
    @output = ""
    @s.each do |s|
      @output += "#{s.hostname} (#{s.ip})|#{s.id}\n"
    end
    render :text => @output
  end

    # GET /servers
    # GET /servers.xml
  def index
    if params[:service_id].nil?
      @servers = subdomain.servers
    else
      @servers = subdomain.services.find(params[:service_id]).servers
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @servers }
    end
  end

  def alive
    @server = Server.find(params[:id])
    render :text => pingecho(@server.ip, 2)[0]
  end

    # GET /servers/1
    # GET /servers/1.xml
  def show
    #logger.info user_is_restricted_to_these_groups.to_yaml
    if user_is_restricted_to_these_groups == 0
      @server = subdomain.servers.find(params[:id])
    else
      @group = subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.where(:group_id => params[:group_id]).first.group
      @server = @group.servers.where(:id => params[:id]).first
    end
  end

    # GET /servers/new
    # GET /servers/new.xml
  def new
    @server = Server.new
  end

    # GET /servers/1/edit
  def edit
    @server = Server.find(params[:id])
  end

    # POST /servers
    # POST /servers.xml
  def create
    @server = Server.new(params[:server])
    @server.domain_id = subdomain_id
    respond_to do |format|
      if @server.save
        format.html { redirect_to(@server, :notice => 'Server was successfully created.') }
        format.xml { render :xml => @server, :status => :created, :location => @server }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

    # PUT /servers/1
    # PUT /servers/1.xml
  def update
    @server = Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html { redirect_to(@server, :notice => 'Server was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

    # DELETE /servers/1
    # DELETE /servers/1.xml
  def destroy
    @server = Server.find(params[:id])
    @server.destroy
    redirect_to servers_url, :notice => "Server deleted."
  end

  private
    # check to see if a user owns this server
  def ownership_required
    begin
      @server = Server.find(params[:id], :conditions => ["domain_id = ?", subdomain_id])
    rescue
      redirect_to servers_path, :notice => "Server not found."
    end
  end

  private
  def check_limits
    if subdomain.servers.size >= subdomain.server_limit
      flash[:error] = "You must delete a Server monitor or upgrade your package to add another."
      redirect_to servers_path
    end
  end


end
