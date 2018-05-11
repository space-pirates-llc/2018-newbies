# frozen_string_literal: true

FactoryBot.define do
  factory :remit_request_result do
    association :user, factory: :user
    association :requested_user, factory: :user
    amount 100
    result 'accepted'

    trait :accepted do
    end

    trait :rejected do
      result 'rejected'
    end

    trait :canceled do
      result 'canceled'
    end
  end
end
