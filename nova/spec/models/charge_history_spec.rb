require 'rails_helper'

RSpec.describe ChargeHistory, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  describe 'validation' do
    subject (:charge_history) { build(:charge_history, amount: amount) }

    context "when nil amount" do
      let(:amount) { nil }
      it { is_expected.not_to be_valid }
    end

    context "when negative amount" do
      let(:amount) { -100 }
      it { is_expected.not_to be_valid }
    end

    context "when zero amount" do
      let(:amount) { 0 }
      it { is_expected.to be_valid }
    end

    context "when too large amount" do
      let(:amount) { 100_000_000 }
      it { is_expected.not_to be_valid }
    end

    context "when max amount" do
      let(:amount) { 99_999_999 }
      it { is_expected.to be_valid }
    end
  end
end
