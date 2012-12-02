class CollectiveStat < ActiveRecord::Base
  belongs_to :domain
  attr_accessible :domain_id, :net_in, :net_out, :net_total, :cpu_usage, :number_of_cpus, 
    :memory_free, :memory_used, :net_connections, :disk_used, :disk_size
  # CPU / NCPU
  #
  # NETWORK
  #
  # MEMORY
  #
  # NETWORK CONNS
  def self.total_mem(hours, subdomain_id)
    beginning = Time.now.advance(:hours => -hours)
    x = CollectiveStat.where("created_at > ? AND domain_id = ?", beginning, subdomain_id)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect{|s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, ((s.mem_used+s.mem_free)/1024/1024).to_f]}
    arr.to_s
  end

  def self.used_mem(hours, subdomain_id)
    beginning = Time.now.advance(:hours => -hours)
    x = CollectiveStat.where("created_at > ? AND domain_id = ?", beginning, subdomain_id)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect{|s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, ((s.mem_used)/1024/1024).to_f]}
    arr.to_s
  end

  def self.cpu_usage(hours, subdomain_id)
    beginning = Time.now.advance(:hours => -hours)
    x = CollectiveStat.where("created_at > ? AND domain_id = ?", beginning, subdomain_id)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    #x.in_groups_of(5){ |g|
    #  begin
    #    p g.collect{|gg| gg["cpu_usage"] }
    #    arr << [g[0].created_at.advance(:hours=>timeoffset).to_i*1000, g.collect{|gg| gg["cpu_usage"].to_f }.weighted_mean([1]*g.size).to_f]
    #  rescue; end
    #}
    x.collect{|s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.cpu_usage).to_f]}

    #x.collect.each_with_index do |s,y|
    #    tmp_averaged = x[y..y+5].map{|ss| ss.cpu_usage.to_f}
    #    arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, tmp_averaged.average]
    #  end
    arr.to_s
  end

  def self.ncpus(hours, subdomain_id)
    beginning = Time.now.advance(:hours => -hours)
    x = CollectiveStat.where("created_at > ? AND domain_id = ?", beginning, subdomain_id)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect{|s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.number_of_cpus).to_f]}
    arr.to_s
  end

  def self.net_in(hours, subdomain_id)
    beginning = Time.now.advance(:hours => -hours)
    x = CollectiveStat.where("created_at > ? AND domain_id = ?", beginning, subdomain_id)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect{|s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.net_in*8/1024/1024).to_f]}
    arr.to_s
  end
  
  def self.net_out(hours, subdomain_id)
    beginning = Time.now.advance(:hours => -hours)
    x = CollectiveStat.where("created_at > ? AND domain_id = ?", beginning, subdomain_id)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect{|s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.net_out*8/1024/1024).to_f]}
    arr.to_s
  end

  def self.net_total(hours, subdomain_id)
    beginning = Time.now.advance(:hours => -hours)
    x = CollectiveStat.where("created_at > ? AND domain_id = ?", beginning, subdomain_id)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect{|s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.net_total*8/1024/1024).to_f]}
    arr.to_s
  end


  def self.connections(hours, subdomain_id)
    beginning = Time.now.advance(:hours => -hours)
    x = CollectiveStat.where("created_at > ? AND domain_id = ?", beginning, subdomain_id)
    arr = []
    timeoffset = Time.zone.utc_offset/(60*60)
    Time.now.dst? ? timeoffset += 1 : 0
    x.collect{|s| arr << [s.created_at.advance(:hours=>timeoffset).to_i*1000, (s.net_connections).to_f]}
    arr.to_s
  end


end
