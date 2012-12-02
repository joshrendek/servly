require 'resolv-replace'

def pingecho(host, timeout=5, service="echo")
  retval = true
  elapsed_time = 0
  begin
    start = Time.now
    timeout(timeout) do
      s = TCPSocket.new(host, service)
      s.close
    end
    elapsed_time = Time.now - start
  rescue Errno::ECONNREFUSED
    retval = false
  rescue Timeout::Error, StandardError
    retval = false
  end

  begin
    if retval == false
      ip = host
      sanitized_ip = []
      ip.split('.').each do |i|
        sanitized_ip << i.to_i
      end
      start = Time.now
      test = `ping -c 1 #{sanitized_ip.join('.')}`
      logger.info "ping -c 1 #{sanitized_ip.join('.')}"
      p "Unix ping #{ip}"
      if test.include?('100% packet loss') || test.include?('100.0% packet loss')
        retval = false
      else
        retval = true
      end
      elapsed_time = Time.now - start
    end
  rescue
    retval = false
    elapsed_time = Time.now - start
  end
  [retval,elapsed_time]
end

