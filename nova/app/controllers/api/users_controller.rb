# frozen_string_literal: true

class Api::UsersController < Api::ApplicationController
  def show
    render json: current_user
  end

  def update
    if user_params[:password] && user_params[:password_confirmation]
      current_user.update!(nickname: user_params[:nickname],
                           email: user_params[:email]&.downcase,
                           password: user_params[:password],
                           password_confirmation: user_params[:passoword_confirmation])
    else
      current_user.update_columns(nickname: user_params[:nickname], email: user_params[:email])
    end

    render json: current_user
  rescue ActiveRecord::RecordInvalid => e
    record_invalid(e)
  end

  protected

  def user_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
  end
end
