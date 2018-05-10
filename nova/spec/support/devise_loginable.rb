module RSpec::LoginHelper
  protected

  def sign_in(user = nil)
    user ||= FactoryBot.create(:user)
    self.current_user = user
    user
  end
end

RSpec.configure do |config|
  config.include(RSpec::LoginHelper, type: :controller)
end
