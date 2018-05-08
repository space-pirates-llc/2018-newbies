# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  include Loginable

  protect_from_forgery with: :exception
end
