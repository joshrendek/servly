require 'net/ssh'
t1 = Time.now

threads = []
retvals = []
for host in DiagnosticWorker.all
  threads << Thread.new(host){ |h|
    p "Pinging #{h.ip}"
    output = nil
    Net::SSH.start(h.ip, 'root', {:port => 66}) do|ssh|
      output = ssh.exec!("ping -c 2 #{h.ip}")
    end
    if output.include?('100% packet loss') || output.include?('100.0% packet loss')
      retvals << 0
      p "Failure #{h.ip} -> ServerIP"
    else
      retvals << 1
    end
  }
end


threads.each { |t| t.join }

if retvals.mean <= 0.33
  p "Sending alerts [mean: #{retvals.mean}"
end
p retvals.sum

p "Elapsed: #{t2-t1}"
