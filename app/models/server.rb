class Server < ActiveRecord::Base
  belongs_to :domain
  belongs_to :group
  belongs_to :group_servers
  has_many :alerts
  has_many :triggered_alerts
  has_many :logs
  has_many :automated_tasks
  has_many :monitored_services
  has_many :server_logs
  has_many :server_services
  has_many :alerts, :as => :targetable
  has_many :diagnostic_logs
  has_many :server_downtimes

  attr_accessible :domain_id, :group_id, :hostname, :ip, :location, :blk_reads, :net_out, :cpu_usage, :running_procs, :blk_writes, 
                  :mem_free, :load_fifteen, :pending_updates, :mem_used, :disk_used, :load_five, :disk_size, :connections, :net_in, :os, :ps, :kernel, :release, :uptime, :load_one, :number_of_cpus


  validates_presence_of :ip

  def server_uptime(months = 1)
    total = months * 31 * 24 * 12 * 5
    100.0 - ((self.server_downtimes.where(:created_at => Time.now.advance(:months => -months)..Time.now).size.to_f)/total.to_f) * 100.0
  end

  def downtime
    dl = self.server_downtimes.where(:created_at => Time.now.advance(:months => -1)..Time.now)
    dl.count(:order => 'DATE(created_at) DESC', :group => ["DATE(created_at)"])
  end

  def traceroute
    DiagnosticWorker.all.each do |d|
      x = self.diagnostic_logs.create(:command => "traceroute -w 2 #{sanitize_ip(d.ip)}",
                                      :domain_id => self.domain, :diagnostic_worker_id => d.id, :tag => 'traceroute')
      x.delay.run
    end
  end

  def mtr
    DiagnosticWorker.all.each do |d|
      x = self.diagnostic_logs.create(:command => "mtr --report --report-cycles 10 #{sanitize_ip(d.ip)} 2> /dev/null",
                                      :domain_id => self.domain, :diagnostic_worker_id => d.id, :tag => 'mtr')
      x.delay.run
    end
  end

  def ping
    DiagnosticWorker.all.each do |d|
      x = self.diagnostic_logs.create(:command => "ping -W 1 -c 4 #{sanitize_ip(d.ip)}",
                                      :domain_id => self.domain, :diagnostic_worker_id => d.id, :tag => 'ping')
      x.delay.run
    end
  end

  def check_if_past_due
  end

  def generic_graph(column, hours, multiplier = 1, to_float = false)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0

    cols = column.split('+')

    if hours >= 48
      x.collect.each_with_index do |s, y|
        tmp_averaged = x[y..y+24].map { |ss| xx = 0; cols.map { |cc| xx+=ss[cc] }; xx }
        if to_float
          arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, tmp_averaged.average.to_f*multiplier.to_f]
        else
          arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, tmp_averaged.average*multiplier]
        end
      end
    else
      x.collect { |s| xx = 0; cols.map { |cc| xx += s[cc] }; arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, xx*multiplier] }
    end

    arr.to_s
  end

  def server_graph_cpu(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, s.cpu_usage] }
    arr.to_s
  end

  def server_graph_procs(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, s.running_procs] }
    arr.to_s
  end

  def server_graph_connections(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.connections)] }
    arr.to_s
  end

  def server_graph_net_in(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.net_in*8/1024/1024).to_f.round_to(2)] }
    arr.to_s
  end

  def server_graph_net_out(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.net_out*8/1024/1024).to_f.round_to(2)] }
    arr.to_s
  end

  def server_graph_disk_size(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.disk_size/1024/1024/1024).to_f] }
    arr.to_s
  end

  def server_graph_disk_used(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.disk_used/1024/1024/1024).to_f] }
    arr.to_s
  end

  def server_graph_mem_used(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.mem_used/1024/1024).to_f] }
    arr.to_s
  end

  def server_graph_mem_total(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, ((s.mem_used+s.mem_free)/1024/1024).to_f] }
    arr.to_s
  end

  def server_graph_load_one(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, s.load_one] }
    arr.to_s
  end

  def server_graph_load_five(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, s.load_five] }
    arr.to_s
  end


  def server_graph_load_fifteen(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, s.load_fifteen] }
    arr.to_s
  end

  def server_graph_blk_reads(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, s.blk_reads] unless s.blk_reads.nil? }
    arr.to_s
  end

  def server_graph_blk_writes(hours)
    beginning = Time.now.advance(:hours => -hours)
    x = self.server_logs.where("created_at > ?", beginning)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect { |s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, s.blk_writes] unless s.blk_writes.nil? }
    arr.to_s
  end


  def self.bandwidth_usage(server_id, days = 31)
    beginning = Time.now.advance(:days => -days)
    server = Server.find(server_id)
    x = server.server_logs.where("created_at > ?", beginning)
    netin = 0
    netout = 0
    for i in (0..(x.size-2)) # avoid last record
      time_in_distance = (x[i+1].created_at - x[i].created_at)
      netin += x[i].net_in * time_in_distance
      netout += x[i].net_out * time_in_distance
    end
    server.estimated_bandwidth = ((netin*8)+(netout*8))
    server.save
  end


    # thresholds
  def self.threshold(previous, now)
    diff = (100-(previous.to_f/now.to_f)*100).a bs
    return true unless diff < 90
  end

  def self.colorize(text, used)
    used <= 40 ? color = "#00D53B" : used > 40 && used <= 90 ? color = "#EBB956" : color = "#ff5a00"
    return "<div class='percent_container'>
              <span align='center' style= 'color: #{color}'>#{text}</span>
              </div>"

  end

  def self.percent_display(used)
    begin
      used <= 40 ? bg = "good.gif" : used > 40 && used <= 90 ? bg = "warn.gif" : bg = "bad.gif"
      used <= 40 ? color = "#00D53B" : used > 40 && used <= 90 ? color = "#EBB956" : color = "#ff5a00"
    rescue
      color = ''
      used = 'NA'
    end
    return "<div class='percent_container'>
            <span align='center' style='color: #{color}'>#{used}%</span>
            </div>"
  end

    #reverse of above
  def self.rpercent_display(used)
    used >= 40 ? bg = "good.gif" : used < 40 && used >= 90 ? bg = "warn.gif" : bg = "bad.gif" rescue nil
    used >= 40 ? color = "#bef8c2" : used < 40 && used >= 90 ? color = "#ff5a00" : color = "#efa5a0" rescue nil
    return "<div class='percent_container'>
            <span align='center ' style='color: #{color}'>#{used}%</span>
            </div>"
  end

  def self.os_type(os)
    os.rstrip == 'Linux' ? "Linux.png" : os.rstrip == 'SunOS' ? "solaris.png" : os.rstrip == 'FreeBSD' ? "freebsd.png" : os.rstrip == 'Windows' ? "Windows.png" : "" rescue nil
  end

  def self.load_color(load, ncpus)
    load = (load.to_f/ncpus.to_f).to_f
    load <= 1.5 ? "healthy" : load > 1.5 && load < 2.5 ? "warn" : "dieng" rescue nil
  end

  def self.cpu_color(cpu)
    cpu >= 90 ? "healthy" : cpu < 90 && cpu > 40 ? "warn" : "dieng" rescue nil
  end

  def self.cpu_used_color(cpu_used)
    cpu_used.nil? ? cpu_used = 0 : " "
    cpu = 100-cpu_used
    cpu <= 40 ? "healthy" : cpu > 40 && cpu < 90 ? "warn" : "dieng" rescue nil
  end

  def self.mem_color(free, used, type)
    begin
      total = free+used
    rescue
      total = 1
      free = 0
      used = 0
    end
    free_per = ((free.to_f/total.to_f)*100).to_i rescue nil
    used_per = ((used.to_f/total.to_f)*100).to_i rescue nil
    if type=="free"
      free_per >= 50 ? "healthy" : free_per < 50 && free_per > 10 ? "warn" : "dieng"
    elsif type=="used"
      used_per <= 60 ? "healthy" : used_per > 60 && used_per < 90 ? "warn" : "dieng"
    end

  end

  def self.disk_color(size, used, type)
    begin
      total = size+used
    rescue
      size = 0
      used = 0
      total = 1
    end
    free_per = (((size.to_f-used.to_f)/total.to_f)*100).to_i
    used_per = ((used.to_f/total.to_f)*100).to_i
    if type=="free"
      free_per >= 50 ? "healthy" : free_per < 50 && free_per > 10 ? "warn" : "dieng"
    elsif type=="used"
      used_per <= 40 ? "healthy" : used_per > 40 && used_per < 90 ? "warn" : "dieng"
    end

  end

  def self.procs_color(procs)
    procs <= 1200 ? "healthy" : procs > 1200 && procs < 1900 ? "warn" : "dieng" rescue nil
  end

  private
  def sanitize_ip(ip)
    sanitized_ip = []
    self.ip.split('.').each do |i|
      sanitized_ip << i.to_i
    end
    sanitized_ip.join('.')
  end

end
