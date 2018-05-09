# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # configure_sign_in_paramsしなくてもstrong parameterにできているか要確認
  # before_action :configure_sign_in_params, only: [:create]

  def new
    super
  end

  def create
    super
    flash.now[:notice] = 'trial'
    flash.now[:alert] = 'trial2'
  end

  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
