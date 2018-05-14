# frozen_string_literal: true

FactoryBot.define do
  factory :remit_request do
    user { create(:user) }
    target { create(:user) }
    amount 100

    trait :outstanding do
      status :outstanding
    end

    trait :accepted do
      status :accepted
    end

    trait :rejected do
      status :rejected
    end

    trait :canceled do
      status :canceled
    end
  end
end
