class TriggeredAlertsController < ApplicationController
  skip_before_filter :restricted_to_groups, :only => [:index, :mark, :new]

  before_filter :set_servers

  def index
    tmp = subdomain.triggered_alerts.order("id desc").page(params[:page])
    trigs = []
    tmp.each do |t|
      if user_is_restricted_to_these_groups == 0 || ( user_is_restricted_to_these_groups != 0 && ( !t.triggerable.nil? && @servers.include?(t.triggerable.id) ) )
        trigs << t.id
      end
    end
    if user_is_restricted_to_these_groups == 0
      @trigger = tmp
    else
      @trigger = subdomain.triggered_alerts.where(:id => trigs).order("id desc").page(params[:page])
    end
  end

  def mark
    du = subdomain.domain_users.where(:user_id => current_user).first
    du.triggered_alert_id = params[:mark]
    du.save
    flash[:message] = "Alerts marked as read."
    redirect_to triggered_alerts_new_path
  end

  def new
    last = subdomain.domain_users.where(:user_id => current_user).first.triggered_alert_id
    last.nil? ? last = 0 : ''
    tmp = subdomain.triggered_alerts.where("id > ?", last).order("id desc").page(params[:page])
    trigs = []
    tmp.each do |t|
      if user_is_restricted_to_these_groups == 0 || ( user_is_restricted_to_these_groups != 0 && ( !t.triggerable.nil? && @servers.include?(t.triggerable.id) ) )
        trigs << t.id
      end
    end
    if user_is_restricted_to_these_groups == 0
      @trigger = tmp
    else
      @trigger = subdomain.triggered_alerts.where(:id => trigs).order("id desc").page(params[:page])
    end

  end

  def old
  end

  private
  def set_servers
    if user_is_restricted_to_these_groups != 0

      group_ids = subdomain.domain_users.find_by_user_id(current_user.id).domain_user_group_permissions.collect {|g| g.group_id }
      tmp = []
      subdomain.group_servers.where(:group_id => group_ids).each do |s|
        tmp << s.server
      end
      @servers = tmp.collect{ |s| s.id }
    end
  end
end

