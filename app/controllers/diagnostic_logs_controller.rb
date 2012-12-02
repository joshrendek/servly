class DiagnosticLogsController < ApplicationController
  layout 'application', :except => [:show]

  skip_before_filter :restricted_to_groups, :only => [:show, :index, :run]


  def index
    if user_is_restricted_to_these_groups == 0
      @server = subdomain.servers.find(params[:server_id])
    else
      @group = subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.where(:group_id => params[:group_id]).first.group
      @server = @group.servers.where(:id => params[:server_id]).first
    end
    @diaglog = @server.diagnostic_logs.order('id desc').page(params[:page])
  end

  def show

    if user_is_restricted_to_these_groups == 0
      @server = subdomain.servers.find(params[:server_id])
    else
      @group = subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.where(:group_id => params[:group_id]).first.group
      @server = @group.servers.where(:id => params[:server_id]).first
    end
    @diaglog = @server.diagnostic_logs.find(params[:id])
  end

  def run
    cmd = params[:command]
    if user_is_restricted_to_these_groups == 0
      @server = subdomain.servers.find(params[:server_id])
    else
      @group = subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.where(:group_id => params[:group_id]).first.group
      @server = @group.servers.where(:id => params[:server_id]).first
    end

    if cmd == 'ping'
      @server.ping
    elsif cmd == 'traceroute'
      @server.traceroute
    elsif cmd == 'mtr'
      @server.mtr
    end

    flash[:message] =  "Command running..."
    if @group.nil?
      redirect_to server_diagnostic_logs_path(@server)
    else
      redirect_to group_server_diagnostic_logs_path(@group, @server)
    end
  end


end
