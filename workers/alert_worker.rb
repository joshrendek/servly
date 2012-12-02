class AlertWorker
  @queue = :alerts

  # Expects id
  def self.perform(alert_id)
    @logger = Logger.new(STDOUT)
    a = Alert.find(alert_id)
    d = a.domain
    tn = Time.now
    ts = Time.utc(2000,1,1,a.start_time.hour,a.start_time.min)
    te = Time.utc(2000,1,1,a.end_time.hour,a.end_time.min)
    tn = Time.utc(2000,1,1,tn.hour, tn.min)
    server_hash = d.servers
    if a.targetable_type == "Server"
      server_hash = [a.targetable]
    end
    #p "#{tn} >= #{ts} && #{tn} <= #{te}"
    if tn >= ts && tn <= te
      server_hash.each do |s|
        begin
          if (s[a.threshold_stat].to_f > a.threshold_value.to_f && a.operator == 'gt')
            alert_operator='above'
            if a.alertable_type == "Domain"
              d.users.each do |u|
                if u.alerts
                  p "Sending alert to: #{u.email} for server #{s.id}"
                  AlertMailer.send_alert(u.email, "", "[SERVLY ALERT: #{s.hostname}'s #{a.threshold_stat.humanize} has gone #{alert_operator} #{a.threshold_value}]", s).deliver
                end
                d.triggered_alerts.create(:alert_id => a.id, :triggerable => s)
              end
            end

            if a.alertable_type == "Team"
              a.alertable.users.each do |u|
                if u.alerts
                  p "Sending alert to: #{u.email} for server #{s.id}"
                  AlertMailer.send_alert(u.email, "", "[SERVLY ALERT: #{s.hostname}'s #{a.threshold_stat.humanize} has gone #{alert_operator} #{a.threshold_value}]", s).deliver
                end
                d.triggered_alerts.create(:alert_id => a.id, :triggerable => s)
              end
            end

            if a.alertable_type == "User"
              if a.alertable.alerts
                p "Sending alert to: #{a.alertable.email} for server #{s.id}"
                AlertMailer.send_alert(a.alertable.email, "", "[SERVLY ALERT: #{s.hostname}'s #{a.threshold_stat.humanize} has gone #{alert_operator} #{a.threshold_value}]", s).deliver
              end
              d.triggered_alerts.create(:alert_id => a.id, :triggerable => s)
            end


          end
        rescue NoMethodError;
        end

        begin
          if (s[a.threshold_stat].to_f < a.threshold_value.to_f && a.operator == 'lt')
            alert_operator='below'
            if a.alertable_type == "Domain"
              d.users.each do |u|
                if u.alerts
                  p "Sending alert to: #{u.email} for server #{s.id} since #{s[a.threshold_stat]} < #{a.threshold_value}"
                  AlertMailer.send_alert(u.email, "", "[SERVLY ALERT: #{s.hostname}'s #{a.threshold_stat.humanize} has gone #{alert_operator} #{a.threshold_value}]", s).deliver
                end
                d.triggered_alerts.create(:alert_id => a.id, :triggerable => s)
              end
            end

            if a.alertable_type == "Team"
              a.alertable.users.each do |u|
                if u.alerts
                  p "Sending alert to: #{u.email} for server #{s.id} since #{s[a.threshold_stat]} < #{a.threshold_value}"
                  AlertMailer.send_alert(u.email, "", "[SERVLY ALERT: #{s.hostname}'s #{a.threshold_stat.humanize} has gone #{alert_operator} #{a.threshold_value}]", s).deliver
                end
                d.triggered_alerts.create(:alert_id => a.id, :triggerable => s)
              end
            end

            if a.alertable_type == "User"
              if a.alertable.alerts
                p "Sending alert to: #{u.email} for server #{s.id} since #{s[a.threshold_stat]} < #{a.threshold_value}"
                AlertMailer.send_alert(a.alertable.email, "", "[SERVLY ALERT: #{s.hostname}'s #{a.threshold_stat.humanize} has gone #{alert_operator} #{a.threshold_value}]", s).deliver
              end
              d.triggered_alerts.create(:alert_id => a.id, :triggerable => s)
            end

          end
        rescue NoMethodError;
        end

      end
    end
  end 
end
