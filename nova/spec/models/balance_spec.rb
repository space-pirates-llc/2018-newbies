require 'rails_helper'

RSpec.describe Balance, type: :model do
  describe 'factory validation' do
    subject(:balance) { create(:user) }

    it { is_expected.to be_valid }
  end

  describe 'Association' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validation' do
    subject(:balance) { create(:user).balance }

    describe 'amount' do
      it { is_expected.to validate_presence_of(:amount) }
      it { is_expected.to validate_numericality_of(:amount).is_greater_than(0).is_less_than(100000) }
    end
  end
end
