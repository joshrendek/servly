class StatusController < ApplicationController
  skip_before_filter :authenticate_user!, :check_permissions
  skip_before_filter :verify_domain_user
  skip_before_filter :check_server_num
  skip_before_filter :restricted_to_groups
  skip_before_filter :verify_active


  protect_from_forgery :only => [:create, :destroy]

  before_filter :verify_key, :except => [:health]


  def elb_check 
    render :text => "ok"
  end



  def update
    # if Rails.env == 'development'
      # @ip = "127.0.0.1"
    # else 
    @ip = request.env['REMOTE_ADDR']#.split(",")[0]
    logger.info @ip
    # end
    

    if params[:server_id].nil? || params[:server_id] == "0"
      @server = Server.find(:first, :conditions => ["ip = ? AND domain_id = ?", @ip, subdomain_id])
    else
      @server = Server.find(params[:server_id])
    end

    if subdomain.servers.size <= subdomain.server_limit
      if @server
        t2 = Time.now
        @s = Server.update(@server.id, params[:srvly])
        @s.save
        logger.info "[update] Timer: #{Time.now-t2}"

        srvly = params[:srvly]

        t2 = Time.now
        # store them in the log db
        statlog1 = params[:srvly]
        params[:srvly].delete('ps')
        begin
          params[:srvly].delete('uptime')
        rescue;
        end
        params[:srvly][:kernel] = ""
        params[:srvly][:release] = ""
        statlog2 = {:server_id => @server.id, :domain_id => subdomain_id}
        @sl = ServerLog.create(statlog1.merge(statlog2))
        @sl.save!

        logger.info "[server_log_create] Timer: #{Time.now-t2}"

        # update RRDs
        cpu_used = 100-srvly[:cpu_free].to_i

        disk_avail = srvly[:disk_size].to_i - srvly[:disk_used].to_i

        t2 = Time.now
        #update health status
        health = []
        health << Server.cpu_color(@server.cpu_usage)
        health << Server.cpu_used_color(@server.cpu_usage)
        health << Server.procs_color(@server.running_procs)
        health << Server.load_color(@server.load_one, @server.running_procs)
        health << Server.load_color(@server.load_five, @server.running_procs)
        health << Server.load_color(@server.load_fifteen, @server.running_procs)
        health << Server.mem_color(@server.mem_free, @server.mem_used, "free")
        health << Server.mem_color(@server.mem_free, @server.mem_used, "used")
        health << Server.disk_color(@server.disk_size, @server.disk_used, "free")
        health << Server.disk_color(@server.disk_size, @server.disk_used, "used")

        logger.info "[health] Timer: #{Time.now-t2}"
      else 
        if Server.where(:ip => @ip, :domain_id => subdomain_id).first.nil?
          s = Server.create(:hostname => @ip, :domain_id => subdomain_id, :ip => @ip)
          s.save
          @s = Server.update(s.id, params[:srvly])
          @s.save
        end
      end


      p "\n\n\n\n\n"
      #logger.info params[:services]

      t2 = Time.now
      param_services = []
      begin
        params[:services].gsub('}', '').gsub('{', '').split(',').each do |m|
          tmp = m.split(':')
          tmp[0].gsub!('\'', '')
          param_services << [tmp[0].chomp.strip, tmp[1].chomp.to_i]
        end
      rescue NoMethodError

      end
      logger.info "[service_parse] Timer: #{Time.now-t2}"

      p "SERVICES"
      p @ip


      t2 = Time.now
      param_services.each do |k|
        srv = subdomain.services.find(:first, :conditions => ["service_variable = ?", k[0]])
        if !srv.nil?
          # check if exists first
          server_service = ServerService.find(:first,
                                              :conditions => ["server_id = ? AND domain_id = ?
                                               AND service_id = ?", @s.id, subdomain_id, srv.id])
                                               if server_service.nil?
                                                 #ServerService.create(:server_id => @s.id, :domain_id => subdomain_id, :service_id => srv.id,
                                                 #                     :status => k[1])
                                               else
                                                 ServerService.update(server_service, :status => k[1])
                                               end
        end
      end

      logger.info "[server_service] Timer: #{Time.now-t2}"


      # t2 = Time.now
      # Resque.enqueue(BandwidthUsageWorker, @s.id)
      # @s.estimated_bandwidth = @s.bandwidth_usage
      # @s.save
      # logger.info "[estimated_bandwidth] Timer: #{Time.now-t2}"

      render :text => "Server updated", :status => 200
    else
      render :text => "You must delete a Server monitor or upgrade your package to add another.", :status => 200
    end

  end

  private
  def check_limits
    if subdomain.servers.size >= subdomain.server_limit
      render :text => "You must delete a Server monitor or upgrade your package to add another."
      raise "overlimit"
    end
  end


end
