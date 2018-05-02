# frozen_string_literal: true

module Loginable
  extend ActiveSupport::Concern
  include ActionController::Cookies

  COOKIE_NAME = :nuid # Nove User ID

  included do
    helper_method :logged_in?
    helper_method :current_user
  end

  protected

  def logged_in?
    current_user.present?
  end

  def current_user
    return @current_user if instance_variable_defined?(:@current_user)

    @current_user = User.find_by(id: cookies[COOKIE_NAME].to_s)
  end

  def current_user=(user)
    @current_user = user

    if user
      cookies.permanent[COOKIE_NAME] = {
        value: user.id.to_s,
      }
    else
      cookies.delete(COOKIE_NAME)
    end
  end
end
