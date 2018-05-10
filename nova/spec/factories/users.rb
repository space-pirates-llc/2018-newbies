# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    nickname { FFaker::Internet.user_name }
    email { FFaker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
  after(:build) do |instance|
    binding.pry
    instance.balance ||= build(:balance, user: instance)
  end
end
