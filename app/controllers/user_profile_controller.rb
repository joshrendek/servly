class UserProfileController < ApplicationController

  def index

  end

  def update_profile
    user = current_user
    user.timezone = params[:u][:timezone]
    user.save
    flash[:message] = "Profile updated"
    redirect_to user_profile_index_path
  end

  def sms
  end

  def test_sms
    AlertMailer.send_test_sms_alert(current_user.phone+"@"+current_user.sms_gateway.address, "", "[SERVLY TEST]").deliver
    flash[:message] = "SMS test message sent"
    redirect_to sms_user_profile_index_path
  end

  def update_sms
    @user = current_user
    @user.phone = params[:sms][:phone]
    @user.sms_gateway_id = params[:sms][:gateway_id]
    @user.save
    redirect_to sms_user_profile_index_path
  end
end
