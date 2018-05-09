# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Charge, type: :model do
  describe 'factory validation' do
    subject(:charge) { build(:charge) }

    it { is_expected.to be_valid }
  end

  describe 'Validations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Associations' do
    describe 'amount' do
      it { is_expected.to validate_numericality_of(:amount).is_greater_than(0).only_integer }
      it { is_expected.to validate_presence_of(:amount) }
    end
  end
end
