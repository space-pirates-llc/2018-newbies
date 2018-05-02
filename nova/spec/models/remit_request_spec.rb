# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemitRequest, type: :model do
  subject(:remit_request) { build(:remit_request) }

  it { is_expected.to be_valid }

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
