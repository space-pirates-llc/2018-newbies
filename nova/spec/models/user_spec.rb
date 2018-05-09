# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory validation' do
    subject(:user) { build(:user) }

    it { is_expected.to be_valid }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:received_remit_requests).class_name('RemitRequest').with_foreign_key('target_id').dependent(:destroy) }
    it { is_expected.to have_many(:sent_remit_requests).class_name('RemitRequest').dependent(:destroy) }
    it { is_expected.to have_many(:charges).dependent(:destroy) }
    it { is_expected.to have_one(:credit_card).dependent(:destroy) }
  end

  describe 'Validations' do
    describe 'nickname' do
      it { is_expected.to validate_presence_of(:nickname) }
    end

    describe 'email' do
      subject { described_class.new(nickname: 'valid nickname', email: 'valid@email.com') }

      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email) }
    end

    describe 'password' do
      it { is_expected.to validate_length_of(:password).is_at_least(8) }
    end
  end
end
