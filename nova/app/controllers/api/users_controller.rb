# frozen_string_literal: true

class Api::UsersController < Api::ApplicationController
  def show
    render json: current_user
  end

  def update
    current_user.update!(user_params)

    render json: current_user
  rescue ActiveRecord::RecordInvalid => e
    record_invalid(e)
  end

  protected

  def user_params
    params.require(:user).permit(:nickname, :email, :password)
  end
end
