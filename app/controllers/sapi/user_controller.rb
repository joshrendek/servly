class Sapi::UserController < ApplicationController
  skip_before_filter :authenticate_user!, :verify_domain_user, :check_server_num, :verify_active
  skip_before_filter :restricted_to_groups
  def authorize
    require 'bcrypt'

    begin
      u = User.find_by_email(params[:username])
      d = Domain.find_by_subdomain(params[:subdomain])
      render :text => u.valid_password?(params[:password]) && !d.domain_users.where(:user_id => u.id).nil?
    rescue
      render :text => 'false'
    end
  end

end
