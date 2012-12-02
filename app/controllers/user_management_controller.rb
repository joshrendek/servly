class UserManagementController < ApplicationController
  before_filter :verify_not_owner, :except => [:index, :toggle_alerts]
  def index
    @users = subdomain.users
  end

  def toggle_activation
    @domain_user = subdomain.domain_users.find(params[:id])
    @domain_user.active = 1 - @domain_user.active # toggle
    tdu = subdomain.domain_users.where(:active => 1).size
    if (@domain_user.active) == 1
      tdu += 1
    else
      tdu -= 1
    end

    if tdu <= subdomain.user_limit
      @domain_user.save
      redirect_to user_management_index_path, :notice => "User has been toggled from this domain."
    else
      redirect_to user_management_index_path, :notice => "You must deactivate another user or upgrade your plan to activate another user."
    end
  end



  def toggle_alerts
    @domain_user = subdomain.domain_users.find(params[:id])
    begin
      @domain_user.alerts = !@domain_user.alerts # toggle
    rescue TypeError
      @domain_user.alerts = true
    end
    @domain_user.save
    redirect_to user_management_index_path, :notice => "Alerts has been toggled for this user."
  end

  def destroy
    @domain_user = subdomain.domain_users.find(params[:id])
    @domain_user.destroy
    redirect_to user_management_index_path, :notice => "User has been successfully deleted."
  end
  
  protected
  def verify_not_owner
    if subdomain.user_id == subdomain.domain_users.find(params[:id]).user.id
      redirect_to user_management_index_path, :notice => "You cannot deactivate or delete the account owner"
    end
  end
end
