class ServerLog < ActiveRecord::Base
  belongs_to :domain
  belongs_to :group
  belongs_to :server

  attr_accessible :domain_id, :group_id, :hostname, :ip, :location, :blk_reads, :net_out, :cpu_usage, :running_procs, :blk_writes, :mem_free, :load_fifteen, :pending_updates, 
                  :mem_used, :disk_used, :load_five, :disk_size, :connections, :net_in, :os, :ps, :kernel, :release, :uptime, :load_one, :number_of_cpus
end
