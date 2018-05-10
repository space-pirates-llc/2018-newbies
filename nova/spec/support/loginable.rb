# frozen_string_literal: true

module RSpec::LoginHelper
  protected

  def login!(user = nil)
    user ||= FactoryBot.create(:user)
    user.activated = true
    self.current_user = user
    user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def current_user=(user)
    session[:user_id] = user&.id
  end
end

RSpec.configure do |config|
  config.include(RSpec::LoginHelper, type: :controller)
end
