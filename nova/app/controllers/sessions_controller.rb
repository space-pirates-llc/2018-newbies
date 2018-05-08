# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: user_params[:email])

    if @user&.authenticate(user_params[:password])
      self.current_user = @user
      redirect_to dashboard_path
    else
      # @user を初期化しつつ、 :email の値のみは保持して render :new する
      @user = User.new(email: user_params[:email])

      render :new, status: :bad_request
    end
  end

  def destroy
    self.current_user = nil if logged_in?

    redirect_to login_path
  end

  protected

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
