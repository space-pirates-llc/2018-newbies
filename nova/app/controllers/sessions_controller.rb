# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    puts '------you must see flash message if you see this---------------'
    puts flash
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:user][:email].downcase)
    if user && user.authenticate(params[:user][:password])
      if user.activated?
        # find user.id in the database and put it into session[:user_id]
        log_in user
        #params[:session][:remember_me] ==  '1' ? remember(user) : forget(user)
        #redirect_back_or user
        redirect_to dashboard_path
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render :new, status: :bad_request
    end
  end

  def destroy
    #self.current_user = nil if logged_in?
    log_out if logged_in?
    redirect_to login_path
  end

  protected

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
