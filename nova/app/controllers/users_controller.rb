# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(nickname: user_params[:nickname],
                     email: user_params[:email]&.downcase,
                     password: user_params[:password],
                     password_confirmation: user_params[:passoword_confirmation])

    # Password と Password Confirmation の同一性チェック
    return render :new, status: :bad_request if user_params[:password] != user_params[:password_confirmation]

    @user.save

    # User が save されたかチェック
    return render :new, status: :bad_request unless @user.persisted?

    self.current_user = @user
    redirect_to dashboard_path
  end

  protected

  def user_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
  end
end
