# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(
              nickname: user_params[:nickname],
              email: user_params[:email],
              password: user_params[:password],
            )

    if @user.persisted?
      self.current_user = @user
      redirect_to dashboard_path
    else
      render :new, status: :bad_request
    end
  end

  protected

  def user_params
    params.require(:user).permit(:nickname, :email, :password)
  end
end