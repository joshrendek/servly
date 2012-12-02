module ApplicationHelper

  def triggered_alert_count
    last = subdomain.domain_users.where(:user_id => current_user).first.triggered_alert_id
    last.nil? ? last = 0 : ''
    ta_count = subdomain.triggered_alerts.where("id > ?", last).size

    if user_is_restricted_to_these_groups != 0
      group_ids = subdomain.domain_users.find_by_user_id(current_user.id).domain_user_group_permissions.collect { |g| g.group_id }
      tmp = []
      subdomain.group_servers.where(:group_id => group_ids).each do |s|
        tmp << s.server
      end
      @servers = tmp.collect { |s| s.id }
      tmp = subdomain.triggered_alerts.where("id > ?", last).order("id desc").page(params[:page])
      trigs = []
      tmp.each do |t|
        if user_is_restricted_to_these_groups == 0 || (user_is_restricted_to_these_groups != 0 && (!t.triggerable.nil? && @servers.include?(t.triggerable.id)))
          trigs << t.id
        end
      end
      ta_count = subdomain.triggered_alerts.where(:id => trigs).order("id desc").size
    end

    return ta_count
  end

  def gravatar_url(email)
    require 'digest/md5'
    if email.nil?
      Digest::MD5.hexdigest(current_user.email.downcase)
    else
      Digest::MD5.hexdigest(email.downcase)
    end
  end

  def fav_ico
    if Server.where("domain_id = ? AND updated_at < ?", subdomain_id, Time.now.advance(:minutes => -5)).size == 0
      "favicon"
    else
      "alert_icon"
    end
  end

  def user_is_restricted_to_these_groups
    x = nil
    if subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.size == 0
      x = 0
    else
      y = subdomain.domain_users.where(:user_id => current_user.id).first.domain_user_group_permissions.collect { |g| g.group.id }
      x = []
      x = Group.find(y)
    end
    x
  end

  def usage_report
    out = ""
    out += "Servers: #{subdomain.servers.count}/#{subdomain.server_limit} | URLs: #{subdomain.url_monitors.count}/#{subdomain.server_limit} | "
    out += "Users: #{subdomain.users.count}/#{subdomain.user_limit} | Alerts: #{subdomain.alerts.count}/#{subdomain.alert_limit}"
  end

  def account_subdomain
    request.subdomains[0]
  end

  def account_domain
    begin
      request.subdomains.join('.') + "." + request.domain
    rescue TypeError # nil subdomains
      request.domain
    end
  end


  def subdomain_id
    begin
      Domain.find(:first, :conditions => ["subdomain = ? OR domain = ?", account_subdomain, account_domain]).id
    rescue RuntimeError
      return "Domain not found #{account_subdomain}"
    end
  end

  def subdomain
    begin
      Domain.find(:first, :conditions => ["subdomain = ? OR domain = ?", account_subdomain, account_domain])
    rescue RuntimeError
      return "Domain not found #{account_subdomain}"
    end
  end

  def button_verb
    action_name.capitalize
  end


end
