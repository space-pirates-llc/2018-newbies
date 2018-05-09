# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  describe 'factory validation' do
    subject(:credit_card) { create(:credit_card, source: stripe.generate_card_token) }

    it { is_expected.to be_valid }
  end

  describe 'Association' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validation' do
    subject(:credit_card) { create(:credit_card, source: stripe.generate_card_token) }

    describe 'stripe' do
      # TODO: テストの仕方がわからなかったので一旦保留
    end

    describe 'brand' do
      it { is_expected.to validate_presence_of(:brand) }
    end

    describe 'last4' do
      it { is_expected.to validate_presence_of(:last4) }
    end

    describe 'exp_year' do
      it { is_expected.to validate_numericality_of(:exp_year).is_greater_than_or_equal_to(0).only_integer }
      it { is_expected.to validate_presence_of(:exp_year) }
    end

    describe 'exp_month' do
      it { is_expected.to validate_inclusion_of(:exp_month).in_range(1..12) }
      it { is_expected.to validate_presence_of(:exp_month) }
    end
  end
end
