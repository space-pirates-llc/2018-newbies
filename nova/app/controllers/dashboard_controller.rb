# frozen_string_literal: true

class DashboardController < ApplicationController
  def show
    redirect_to(login_path) unless logged_in?
  end
end
