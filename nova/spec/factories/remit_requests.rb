# frozen_string_literal: true

FactoryBot.define do
  factory :remit_request do
    user { create(:user) }
    requested_user { create(:user) }
    amount 100
  end
end
