require 'rails_helper'

RSpec.describe Balance, type: :model do

  describe 'Association' do
    it { is_expected.to belong_to(:user) }
  end
end
