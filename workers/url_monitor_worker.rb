require 'net/http'
require 'resolv-replace'
class URLMonitorWorker
  @queue = :url_monitor

  # Expects service id
  def self.perform(url_monitor_id)
    @logger = Logger.new(STDOUT)
    s = UrlMonitor.find(url_monitor_id)
    Timeout::timeout(4) do
      @logger.info "[UrlProcess] #{s.url}"
      begin
        start_time = Time.now
        res = RestClient.get(s.url)
        host_resp_time = Time.now - start_time

        status_code = res.code

        response_time = Time.now - start_time

        current_run = res.to_str

        current_status = res.code
        s.update_attributes(:current_run => current_run, :current_status => status_code, :response_time => (response_time-host_resp_time).abs)
        urllog = {:url_monitor_id => s.id, :domain_id => s.domain.id, :created_at => DateTime.now}

        tmp = s.attributes
        tmp.delete('current_run')
        tmp.delete('keyword')
        tmp.delete('status_code')
        tmp.delete('url')
        @sl = UrlMonitorLog.create(tmp.merge(urllog))
        @sl.save!

        if status_code.to_i != 200 && status_code.to_i != 302
          p "Status: #{status_code}"
          s.domain.domain_users.each do |us|
            AlertMailer.send_url_alert(us.user.email, "[SERVLY ALERT: #{s.url} has responded with status: #{current_status}]", s).deliver
            if !us.user.phone.nil? && !us.user.sms_gateway_id.nil?
              AlertMailer.send_sms_alert(us.user.phone+"@"+us.user.sms_gateway.address, "", "[#{s.url} status is #{current_status}]", self).deliver
            end
          end
        end


        p ""
      rescue Exception => e
        p e
        print "Exception occurred on [1]:" + e.backtrace.join("\n")
      end
    end
    @sl
  end
end
