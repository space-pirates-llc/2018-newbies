# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  subject(:credit_card) { create(:credit_card, source: stripe.generate_card_token) }

  it { is_expected.to be_valid }
end
