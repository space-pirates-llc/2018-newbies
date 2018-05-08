# frozen_string_literal: true

class DashboardController < ApplicationController
  def show
    redirect_to(login_path) unless user_signed_in?
  end
end
