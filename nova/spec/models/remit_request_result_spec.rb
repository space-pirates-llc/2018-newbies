# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemitRequestResult, type: :model do
  subject(:remit_request_result) { build(:remit_request_result) }

  it { is_expected.to be_valid }

  describe 'validation' do
    describe 'amount' do
      context 'when amout value is negative' do
        subject(:remit_request_result) { build_stubbed(:remit_request_result, amount: -1) }

        it { is_expected.not_to be_valid }
      end

      context 'when amout is too big' do
        subject(:remit_request_result) { build_stubbed(:remit_request_result, amount: 10**9) }

        it { is_expected.not_to be_valid }
      end

      context 'when amount is empty' do
        subject(:remit_request_result) { build_stubbed(:remit_request_result, amount: nil) }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'result' do
      context 'when result is empty' do
        subject(:remit_request_result) { build_stubbed(:remit_request_result, result: ' ') }

        it { is_expected.not_to be_valid }
      end

      valid_values = %w[accepted rejected canceled]
      valid_values.each do |val|
        context "when result is valid value(#{val})" do
          subject(:remit_request_result) { build_stubbed(:remit_request_result, result: val) }

          it { is_expected.to be_valid }
        end
      end

      invalid_values = %w[foobar test in_progress]
      invalid_values.each do |val|
        context "when result is valid value(#{val})" do
          subject(:remit_request_result) { build_stubbed(:remit_request_result, result: val) }

          it { is_expected.not_to be_valid }
        end
      end
    end

    %i[user_id requested_user_id].each do |column|
      describe column do
        context "when #{column} is empty" do
          subject(:remit_request_result) { build_stubbed(:remit_request_result, column => nil) }

          it { is_expected.not_to be_valid }
        end
      end
    end
  end

  describe 'scope' do
    before do
      5.times do
        create(:remit_request_result, :accepted)
        create(:remit_request_result, :rejected)
        create(:remit_request_result, :canceled)
      end
    end

    %i[accepted rejected canceled].each do |result|
      context "with #{result}" do
        subject do
          RemitRequestResult.send(result.to_s).map(&:result)
        end

        it { is_expected.to all(eq result.to_s) }
      end
    end
  end
end
