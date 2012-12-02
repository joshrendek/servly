class DashboardWorker 
  @queue = :dashboard 

  # Expects a domain object
  def self.perform(domain_id)
    domain = Domain.find(domain_id)
    @logger = Logger.new(STDOUT)
    @logger.info("[Dashboard] for #{domain.id}")
    # check server status's ... if down order a ping and traceroute!
    @servers = Server.find(:all, :conditions => ["domain_id = ? ", domain.id])
    net_out = []
    net_in = []
    net_total = []
    cpu_usage = []
    ncpus = []
    mem_free = []
    mem_used = []
    net_conn = []
    disk_used = []
    disk_size = []
    @servers.collect { |s| 
      begin
        net_out << s.net_out
        net_in << s.net_in
        net_total << s.net_in + s.net_out
        cpu_usage << s.cpu_usage
        ncpus << s.number_of_cpus
        mem_free << s.mem_free
        mem_used << s.mem_used
        net_conn << s.connections
        disk_size << s.disk_size
        disk_used << s.disk_used
      rescue

      end
    }

    begin
      netout = net_out.sum
    rescue
      netout = 0
    end
    begin
      netin = net_in.sum
    rescue
      netin = 0
    end
    begin
      nettotal = net_total.sum
    rescue
      nettotal = 0
    end

    begin
      cpuusage = (cpu_usage.sum/cpu_usage.size)
    rescue ZeroDivisionError
      cpuusage = 0
    end
    ncpu = ncpus.sum
    CollectiveStat.create(:domain_id => domain.id, :net_in => netin, :net_out => netout, :net_total => nettotal, 
                          :cpu_usage => cpuusage, :number_of_cpus => ncpu, :memory_free => mem_free.sum, :memory_used => mem_used.sum,
                          :net_connections => net_conn.sum, :disk_size => disk_size.sum, :disk_used => disk_used.sum)

  end
end
