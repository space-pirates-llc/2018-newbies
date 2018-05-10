# frozen_string_literal: true

FactoryBot.define do
  factory :remit_request do
    user { create(:user) }
    target { create(:user) }
    amount 100

    trait :outstanding do
      accepted_at nil
      rejected_at nil
      canceled_at nil
    end

    trait :accepted do
      accepted_at { Time.current }
    end

    trait :rejected do
      rejected_at { Time.current }
    end

    trait :canceled do
      canceled_at { Time.current }
    end
  end
end
