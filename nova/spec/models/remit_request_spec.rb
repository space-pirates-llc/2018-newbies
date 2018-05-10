# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemitRequest, type: :model do
  subject(:remit_request) { build(:remit_request) }

  it { is_expected.to be_valid }

  describe "method" do
    let(:target_user_amount) { 1000 }

    let(:source_user) do
      user = build(:user)
      user.build_balance(amount: user_amount)
      user.save!
      user
    end
    let(:target_user) do
      user = build(:user)
      user.build_balance(amount: target_user_amount)
      user.save!
      user
    end

    let(:remit_request) do
      create(:remit_request, amount: request_amount, user: source_user, target: target_user)
    end

    describe ".accept!" do
      subject(:accept_subject) { remit_request.accept! }
      context "with enough amount" do
        let (:request_amount) { 5000 }
        let (:user_amount) { 10000 }

        before { subject }

        it "remit_request should be destroyed" do
          expect(RemitRequest.find_by_id(remit_request.id).present?).to eq false
        end

        it "remit_request_result should be created" do
          result = RemitRequestResult.find_by(user_id: source_user.id)
          expect(result.present?).to eq true
          expect(result.amount).to eq request_amount
          expect(result.user).to eq source_user
          expect(result.target).to eq target_user
          expect(result.result).to eq RemitRequestResult::RESULT_ACCEPTED
        end

        it "user's balance should be changed" do
          expect(source_user.balance.amount).to eq (user_amount - request_amount)
        end

        it "target's balance should be changed" do
          expect(target_user.balance.amount).to eq (target_user_amount + request_amount)
        end
      end

      context "without enough amount" do
        let (:request_amount) { 5000 }
        let (:user_amount) { 100 }

        describe "exception test" do
          subject { -> { accept_subject } }
          it { is_expected.to raise_error(RemitRequest::InsufficientBalanceError) }
        end

        describe "not exception test" do
          subject { accept_subject rescue nil }

          before { subject }

          it "remit_request should not be destroyed" do
            expect(RemitRequest.find_by_id(remit_request.id).present?).to eq true
          end

          it "remit_request_result should not be created" do
            expect(RemitRequestResult.find_by(user_id: source_user.id).present?).to eq false
          end

          it "user's balance shouldn't be changed" do
            expect(source_user.balance.amount).to eq user_amount
          end

          it "target's balance shouldn't be changed" do
            expect(target_user.balance.amount).to eq target_user_amount
          end
        end
      end
    end

    describe ".reject!" do
      subject { remit_request.reject! }
      let (:request_amount) { 5000 }
      let (:user_amount) { 10000 }

      before { subject }

      it "remit_request should be destroyed" do
        expect(RemitRequest.find_by_id(remit_request.id).present?).to eq false
      end

      it "remit_request_result should be created" do
        result = RemitRequestResult.find_by(user_id: source_user.id)
        expect(result.present?).to eq true
        expect(result.amount).to eq request_amount
        expect(result.user).to eq source_user
        expect(result.target).to eq target_user
        expect(result.result).to eq RemitRequestResult::RESULT_REJECTED
      end
    end

    describe ".cancel!" do
      subject { remit_request.cancel! }
      let (:request_amount) { 5000 }
      let (:user_amount) { 10000 }

      before { subject }

      it "remit_request should be destroyed" do
        expect(RemitRequest.find_by_id(remit_request.id).present?).to eq false
      end

      it "remit_request_result should be created" do
        result = RemitRequestResult.find_by(user_id: source_user.id)
        expect(result.present?).to eq true
        expect(result.amount).to eq request_amount
        expect(result.user).to eq source_user
        expect(result.target).to eq target_user
        expect(result.result).to eq RemitRequestResult::RESULT_CANCELED
      end
    end
  end
end
