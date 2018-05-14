require 'rails_helper'

RSpec.describe Balance, type: :model do
  describe 'factory validation' do
    subject(:user) { create(:user) }

    it { is_expected.to be_valid }
  end

  describe 'Association' do
    it { is_expected.to belong_to(:user) }
  end
end
