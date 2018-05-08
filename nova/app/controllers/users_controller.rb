# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    print 'I am here---------------------'
    @user = User.create(user_params)

    if @user.persisted?
      self.current_user = @user
      redirect_to dashboard_path
    elsif @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new, status: :bad_request
    end
  end

  protected

  def user_params
    params.require(:user).permit(:nickname, :email, :password)
  end
end
