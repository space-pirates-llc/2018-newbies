require 'rails_helper'

RSpec.describe Balance, type: :model do
  subject (:balance) { build(:balance) }

  it { is_expected.to be_valid }

  describe "validation" do
    describe "user" do
      context "with empty user_id" do
        subject (:balance) { build_stubbed(:balance, user: nil) }

        it { is_expected.not_to be_valid }
      end
    end

    describe "amount" do
      context "with null amount" do
        subject (:balance) { build_stubbed(:balance, amount: nil) }

        it { is_expected.not_to be_valid }
      end

      context "with negative amount" do
        subject (:balance) { build_stubbed(:balance, amount: -100) }

        it { is_expected.not_to be_valid }
      end

      context "with zero amount" do
        subject (:balance) { build_stubbed(:balance, amount: 0) }

        it { is_expected.to be_valid }
      end

      context "with too large amount" do
        subject (:balance) { build_stubbed(:balance, amount: 100_000_000) }

        it { is_expected.not_to be_valid }
      end

      context "with large amount" do
        subject (:balance) { build_stubbed(:balance, amount: 99_999_999) }

        it { is_expected.to be_valid }
      end
    end
  end
end
