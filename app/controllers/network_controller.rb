class NetworkController < ApplicationController
  layout 'application', :except => [:do_pingmap]

  skip_before_filter :restricted_to_groups, :only => [:pingmap, :do_pingmap]

  def pingmap
    if user_is_restricted_to_these_groups == 0
      @servers = Server.find(:all, :conditions => ["domain_id = ?", subdomain_id])
    else
      group_ids = subdomain.domain_users.find_by_user_id(current_user.id).domain_user_group_permissions.collect {|g| g.group_id }
      @servers = []
      subdomain.group_servers.where(:group_id => group_ids).each do |s|
        @servers << s.server
      end
    end
  end
  
  def do_pingmap
    require 'resolv-replace'
    @server = Server.find(params[:id], :conditions => ["domain_id = ?", subdomain_id]) rescue nil
    pe = pingecho("#{@server.ip}", 2)
    @status = pe[0]
    @elapsed_time = pe[1]
  end

  def traceroute
  end

  def ping
  end

  def uptime
    @downtimes = subdomain.server_downtimes.where(:created_at => Time.now.advance(:months => -1)..Time.now)
  end

  
end
