class UserPasswordController < ApplicationController

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.valid_password?(params[:u][:current_password])
      @user.password = params[:u][:password]
      @user.password_confirmation = params[:u][:repeat_password]
      if @user.save
        redirect_to edit_user_password_index_path, :notice => "Password updated." + @user.errors.full_messages.join('<br />')
      else
        redirect_to edit_user_password_index_path, :notice => @user.errors.full_messages.join('<br />')
      end
    else
      redirect_to edit_user_password_index_path, :notice => "Your old password is incorrect."
    end
  end
end
