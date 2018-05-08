# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    #if @user.persisted?
    #  exit
    #  self.current_user = @user
    #  redirect_to dashboard_path
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to signup_url
    else
      flash[:alert] = "Parameters error" 
      render :new, status: :bad_request
    end
  end

  protected

  def user_params
    params.require(:user).permit(:nickname, :email, :password)
  end
end
