# frozen_string_literal: true

class ApplicationController < ActionController::Base
  #include Loginable
  #protect_from_forgery with: :exception

  def after_sign_in_path_for(user)
    dashboard_path
  end
end
