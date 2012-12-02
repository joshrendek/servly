class Api::UserController < ApplicationController
  def authorize
    @user = User.find_by_email(params[:email])
    if @user.valid_password?(params[:password])
      render :json => {"message" => "Success"}
    else
      render :json => {"message" => 'Invalid login'}, :status => :forbidden
    end
  end
end
