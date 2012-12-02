class AlertMailer < ActionMailer::Base
  default :from => "Servly <dnr@servly.com>"

  def send_alert(email, msg, subject, server)
    @server = server
    mail(:to => email, :subject => subject)
  end

  def send_sms_alert(email, msg, subject, server)
    @server = server
    mail(:to => email, :subject => subject)
  end

  def send_test_sms_alert(email, msg, subject)
    mail(:to => email, :subject => subject)
    render :text => "Test Message"
  end

  def send_url_alert(email, subject, url)
    @url = url
    mail(:to => email, :subject => subject)
  end
end
