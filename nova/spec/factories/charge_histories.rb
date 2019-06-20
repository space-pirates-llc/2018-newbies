FactoryBot.define do
  factory :charge_history do
    amount { 100 }
    stripe_id { "ch_123abc" }
    result { "success" }
    association :user, factory: :user
  end
end
