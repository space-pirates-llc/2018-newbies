# frozen_string_literal: true

class Api::UsersController < Api::ApplicationController
  def show
    render json: current_user
  end

  def update
    case user_params[:attribute]
    when 'nickname'
      current_user.update!(nickname: user_params[:nickname])
      render json: current_user
    when 'email'
      current_user.update!(email: user_params[:email]&.downcase)
      render json: current_user
    when 'password'
      # Password と Password Confirmation の同一性チェック
      raise ActiveRecord::RecordInvalid.new if user_params[:password] != user_params[:password_confirmation]

      current_user.update!(password: user_params[:password], password_confirmation: user_params[:passoword_confirmation])
      render json: current_user
    else
      render json: current_user, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    record_invalid(e)
  end

  protected

  def user_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation).merge(attribute: params[:attribute])
  end
end
