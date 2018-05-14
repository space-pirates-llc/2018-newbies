# frozen_string_literal: true

module RSpec::LoginHelper
  protected

  def login!(user = nil)
    user ||= FactoryBot.create(:user)
    self.current_user = user
    user
  end

  def current_user
    User.find_by(id: cookies.encrypted.signed[Loginable::COOKIE_NAME])
  end

  def current_user=(user)
    cookies.encrypted.signed[Loginable::COOKIE_NAME] = {
      value: user&.id&.to_s,
      httponly: true
    }
  end
end

RSpec.configure do |config|
  config.include(RSpec::LoginHelper, type: :controller)
end
