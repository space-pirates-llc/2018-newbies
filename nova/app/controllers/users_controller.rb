# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      @user.send_activation_email
      flash[:notice] = "アカウント有効化のメールを送信しました。"
      redirect_to signup_url
    else
      render :new, status: :bad_request
    end
  end

  protected

  def user_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
  end
end
