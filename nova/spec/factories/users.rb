# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    nickname { FFaker::Internet.user_name }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
  end

  trait :with_request_password_reset do
    reset_digest { User.digest(User.new_token) }
    reset_sent_at { Time.zone.now }
  end

  trait :with_activated do
    activated { true }
    activated_at { Time.zone.now }
  end
end
