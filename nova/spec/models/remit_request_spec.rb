# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemitRequest, type: :model do
  subject(:remit_request) { build(:remit_request) }

  it { is_expected.to be_valid }

  describe "method" do
    let(:request_user_amount) { 1000 }

    let(:request_user) do
      user = build(:user)
      user.build_balance(amount: request_user_amount)
      user.save!
      user
    end
    let(:requested_user) do
      user = build(:user)
      user.build_balance(amount: requested_user_amount)
      user.save!
      user
    end

    let(:remit_request) do
      create(:remit_request, amount: remit_amount, user: request_user, requested_user: requested_user)
    end

    describe ".accept!" do
      subject(:accept_subject) { remit_request.accept! }
      context "with enough amount" do
        let (:remit_amount) { 5000 }
        let (:requested_user_amount) { 10000 }

        before { subject }

        it "remit_request should be destroyed" do
          expect(RemitRequest.find_by_id(remit_request.id).present?).to eq false
        end

        it "remit_request_result should be created" do
          result = RemitRequestResult.find_by(user_id: request_user.id)
          expect(result.present?).to eq true
          expect(result.amount).to eq remit_amount
          expect(result.user).to eq request_user
          expect(result.requested_user).to eq requested_user
          expect(result.result).to eq RemitRequestResult::RESULT_ACCEPTED
        end

        it "request user's balance should be changed" do
          expect(request_user.balance.amount).to eq (request_user_amount + remit_amount)
        end

        it "requested user's balance should be changed" do
          expect(requested_user.balance.amount).to eq (requested_user_amount - remit_amount)
        end
      end

      context "without enough amount" do
        let (:remit_amount) { 5000 }
        let (:requested_user_amount) { 100 }

        describe "exception test" do
          subject { -> { accept_subject } }
          it { is_expected.to raise_error(RemitService::InsufficientBalanceError) }
        end

        describe "not exception test" do
          subject { accept_subject rescue nil }

          before { subject }

          it "remit_request should not be destroyed" do
            expect(RemitRequest.find_by_id(remit_request.id).present?).to eq true
          end

          it "remit_request_result should not be created" do
            expect(RemitRequestResult.find_by(user_id: request_user.id).present?).to eq false
          end

          it "request user's balance shouldn't be changed" do
            expect(request_user.balance.amount).to eq request_user_amount
          end

          it "requested user's balance shouldn't be changed" do
            expect(requested_user.balance.amount).to eq requested_user_amount
          end
        end
      end
    end

    describe ".reject!" do
      subject { remit_request.reject! }
      let (:remit_amount) { 5000 }
      let (:requested_user_amount) { 10000 }

      before { subject }

      it "remit_request should be destroyed" do
        expect(RemitRequest.find_by_id(remit_request.id).present?).to eq false
      end

      it "remit_request_result should be created" do
        result = RemitRequestResult.find_by(user_id: request_user.id)
        expect(result.present?).to eq true
        expect(result.amount).to eq remit_amount
        expect(result.user).to eq request_user
        expect(result.requested_user).to eq requested_user
        expect(result.result).to eq RemitRequestResult::RESULT_REJECTED
      end
    end

    describe ".cancel!" do
      subject { remit_request.cancel! }
      let (:remit_amount) { 5000 }
      let (:requested_user_amount) { 10000 }

      before { subject }

      it "remit_request should be destroyed" do
        expect(RemitRequest.find_by_id(remit_request.id).present?).to eq false
      end

      it "remit_request_result should be created" do
        result = RemitRequestResult.find_by(user_id: request_user.id)
        expect(result.present?).to eq true
        expect(result.amount).to eq remit_amount
        expect(result.user).to eq request_user
        expect(result.requested_user).to eq requested_user
        expect(result.result).to eq RemitRequestResult::RESULT_CANCELED
      end
    end
  end
end
