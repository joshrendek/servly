class DiagnosticLog < ActiveRecord::Base
  belongs_to :domain
  belongs_to :server
  belongs_to :diagnostic_worker
  require 'net/ssh'
  require 'ipaddr'

  attr_accessible :diagnostic_worker_id, :command, :output, :server_id, :domain_id, :tag

  paginates_per 25


  def run
    host = DiagnosticWorker.find(self.diagnostic_worker_id).ip
    output = nil
    Net::SSH.start(host, 'root', {:port => 66}) do|ssh|
      output = ssh.exec!(self.command)
    end
    update_attributes(:output => output)
    output
  end
end
