# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemitRequest, type: :model do
  describe 'factory validation' do
    subject(:remit_request) { build(:remit_request) }

    it { is_expected.to be_valid }
  end

  describe 'statuses' do
    statuses = %i[outstanding accepted rejected canceled]
    statuses.each do |status|
      context "with #{status}" do
        subject(:remit_request) { create(:remit_request, status) }

        it { is_expected.to send(:"be_#{status}") }
        it("should record of #{status} scope") { expect(RemitRequest.send(status)).to include(remit_request) }

        other_statuses = statuses.reject { |s| s == status }
        other_statuses.each do |other_status|
          it { is_expected.to_not send(:"be_#{other_status}") }
          it("should not record of #{other_status} scope") { expect(RemitRequest.send(other_status)).to_not include(remit_request) }
        end
      end
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:target).class_name('User') }
  end

  describe 'Validations' do
    describe 'amount' do
      it { is_expected.to validate_numericality_of(:amount).is_greater_than(0).only_integer }
    end
  end
end
