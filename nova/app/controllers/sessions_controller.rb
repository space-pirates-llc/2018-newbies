# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user && @user.authenticate(params[:user][:password])
      if @user.activated?
        log_in @user
        redirect_to dashboard_path
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      redirect_to login_path, alert: 'ユーザーが存在しないかパスワードが間違っています'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

  protected

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
