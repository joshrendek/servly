class DashboardController < ApplicationController
  def awesome
    @servers = subdomain.servers
  end


  def index
    @servers = Server.find(:all, :conditions => ["domain_id = ?", subdomain_id])
    
    @services = Service.find(:all, :conditions => ["domain_id = ?", subdomain_id])

    @cs = CollectiveStat.find(:last, :conditions => ["domain_id = ?", subdomain_id])
    # new user
    if @servers.size==0
      flash[:message] = "You need to add a server"
      redirect_to("/agent")
    end


    # do overview
    @no_cpus = @cs.try(:number_of_cpus)

    
    
    @os = []
    @servers.collect { |s| !s.os.nil? ? @os << s.os.rstrip : "" }
    @os = @os.uniq.map { |e| [e, (@os.select { |ee| ee == e }).size] }

    @used_mem = @cs.try(:memory_used)
    @free_mem = @cs.try(:memory_free)
    


    @healthy = Server.where("domain_id = ? AND updated_at > ?", subdomain_id, Time.now.advance(:minutes => -5)).size
    @dead = Server.where("domain_id = ? AND updated_at < ?", subdomain_id, Time.now.advance(:minutes => -5)).size


    begin 
      @total_mem = @used_mem + @free_mem
    rescue NoMethodError; @total_mem = 0; end;


    @used_disk = @cs.try(:disk_used)
    @total_disk = @cs.try(:disk_size)

    
    @pending_updates = 0
    @total_connections = 0
    
    begin
      @free_disk = @total_disk-@used_disk
    rescue NoMethodError; @free_disk = 0; end; 

    @net_in = @cs.try(:net_in)
    @net_out = @cs.try(:net_out)

    @net_in.nil? ? @net_in = 0 : 0
    @net_out.nil? ? @net_out = 0 : 0 

    begin
      @net_total = @net_in + @net_out
    rescue NoMethodError; @net_total = 0; end;

    @cpu_usage = @cs.try(:cpu_usage)

    # do top 10s
    # maybe sorting the hashes might be quicker than a query?
    @topten_cpu = Server.find(:all, :conditions => ["domain_id = ?", subdomain_id], :order => "cpu_usage DESC", :limit => 10)

    # memory is tricky.. I was going to write a MySQL query for this but trying to keep database agnostic
    mem_pool = []
    mem_collector = Server.find(:all, :conditions => ["domain_id = ?", subdomain_id]).collect { |s| mem_pool << [s.mem_used.to_f/(s.mem_free+s.mem_used).to_f, s.mem_used.to_f, (s.mem_free+s.mem_used).to_f, s.id] rescue nil }
    @topten_memory = mem_pool.sort.reverse[0..9]

    # net is tricky.. I was going to write a MySQL query for this but trying to keep database agnostic
    net_pool = []
    net_collector = Server.find(:all, :conditions => ["domain_id = ?", subdomain_id]).collect { |s| net_pool << [(s.net_in+s.net_out), s.id] rescue nil }
    @topten_net = net_pool.sort.reverse[0..9] # 0..9   

    # memory is tricky.. I was going to write a MySQL query for this but trying to keep database agnostic
    disk_pool = []
    disk_collector = Server.find(:all, :conditions => ["domain_id = ? AND disk_used > 0", subdomain_id]).collect { |s| disk_pool << [s.disk_used.to_f/(s.disk_size).to_f, s.disk_used.to_f, (s.disk_size).to_f, s.id] }
    begin
      @topten_disk = disk_pool.sort.reverse[0..9]
    rescue
      @topten_disk = []
    end

  end

end
