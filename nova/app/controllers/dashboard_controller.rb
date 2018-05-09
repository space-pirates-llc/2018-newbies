# frozen_string_literal: true

class DashboardController < ApplicationController
  def show
    redirect_to(new_user_session_url) unless user_signed_in?
  end
end
