require 'net/ssh'
require 'timeout'
class ServerStatusWorker
  @queue = :server_status

  # Expects id
  def self.perform(server_id)
    server = Server.find(server_id)
    ip = server.ip
    down_alert_count = server.down_alert_count
    domain = server.domain
    hostname = server.hostname
    @logger = Logger.new(STDOUT)
    begin
      if server.updated_at < Time.now.advance(:minutes => -5) && down_alert_count <= 3

        threads = []
        retvals = []
        if pingecho(ip, 1)[0] == false

          DiagnosticWorker.all.each do |host|
            threads << Thread.new { 
              output = `ping -W 2 -c 2 #{ip}`
              if output.include?('100% packet loss') || output.include?('100.0% packet loss')
                retvals << 0
                p "Failure localhost -> #{ip}"
              else
                retvals << 1
                p "Success localhost"
              end
            }
            threads << Thread.new(host) { |h|
              p "Pinging #{ip}"
              output = nil
              begin 
                Timeout::timeout(3) do 
                  Net::SSH.start(h.ip, 'root', {:port => 66}) do |ssh|
                    output = ssh.exec!("ping -W 2 -c 2 #{ip}")
                  end
                end
              rescue Timeout::Error 
                retvals << 0
                output = ''
              end
              if output.include?('100% packet loss') || output.include?('100.0% packet loss')
                retvals << 0
                p "Failure #{h.ip} -> #{ip}"
              else
                retvals << 1
                p "Success #{h.ip}"
              end
            }
          end
          threads.each { |t| t.join }

        end

        if retvals.mean <= 0.33 # 1/3 or more reported server as unpingable
          time_at_start = server.updated_at
          server.update_attributes(:down_alert_count => server.down_alert_count+1)
          server.ping
          server.traceroute
          server.mtr
          server.server_downtimes.create(:domain_id => server.domain.id)
          server.domain.domain_users.each do |u|
            if u.alerts && !u.user.nil?

              if down_alert_count <= 3

                AlertMailer.send_alert(u.user.email, "", "[SERVLY ALERT: #{hostname} has not responded in 5 minutes]", server).deliver
                if !u.user.phone.nil? && !u.user.sms_gateway_id.nil?
                  AlertMailer.send_sms_alert(u.user.phone+"@"+u.user.sms_gateway.address, "", "[#{hostname} has not responded]", server).deliver
                end

                p "Email sent to #{u.user.email} for server #{id}"
                @logger.error "Email sent to #{u.user.email} for server #{id}"
              else
                p "Email  & SMS skipped, down count @ #{down_alert_count}"
              end

              domain.triggered_alerts.create(:alert_id => nil, :triggerable => server)

            elsif !u.user.nil?
              domain.triggered_alerts.create(:alert_id => nil, :triggerable => server)
            end
          end

          server.updated_at = time_at_start
          server.save

        else

          # Send everything is back up email
          if server.down_alert_count > 0
            server.update_attributes(:down_alert_count => 0)

            server.domain.domain_users.each do |u|
              if u.alerts && !u.user.nil?
                AlertMailer.send_alert(u.user.email, "", "[SERVLY ALERT: #{hostname} server has come back online]", server).deliver
                if !u.user.phone.nil? && !u.user.sms_gateway_id.nil?
                  AlertMailer.send_sms_alert(u.user.phone+"@"+u.user.sms_gateway.address, "", "[#{hostname} server has come back online]", server).deliver
                end
              end
            end
          end

          p "Server responded to ping #{pingecho(ip, 1)}"
          @logger.error "Server responded to ping #{pingecho(ip, 1)}"
        end
      else

      end
    rescue Exception => e
      p e.to_s
    end
  end
end
