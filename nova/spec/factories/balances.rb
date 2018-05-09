FactoryBot.define do
  factory :balance do
    association :user, factory: :user
    amount 1000
  end
end
