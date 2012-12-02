require 'socket'
require 'timeout'
class TcpServicesWorker
  @queue = :tcp_services

  # Expects service id
  def self.perform(service_id)
    @logger = Logger.new(STDOUT)
    s = Service.find(service_id)
    service_port = s.service_variable.to_i
    s.server_services.each do |ss|
      @logger.info "Checking port #{service_port}"
      service_up = false
      begin
        Timeout::timeout(1) do
          begin
            TCPSocket.new(ss.server.ip, service_port)
            service_up = true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, NoMethodError
            service_up = false
          end
        end
      rescue Timeout::Error
      end

      @logger.info "Status: #{service_up}"
      ss.update_attributes(:status => service_up)
    end
  end
end
