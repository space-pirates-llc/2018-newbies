# frozen_string_literal: true

class User < ApplicationRecord
  has_many :received_remit_requests, class_name: 'RemitRequest', foreign_key: :requested_user_id,
           dependent: :destroy
  has_many :sent_remit_requests, class_name: 'RemitRequest', dependent: :destroy
  has_many :received_remit_request_results, class_name: 'RemitRequestResult',
           foreign_key: :requested_user_id
  has_many :sent_remit_request_results, class_name: 'RemitRequestResult', foreign_key: :user_id
  has_many :charge_histories, dependent: :destroy
  has_one :credit_card, dependent: :destroy
  has_one :balance, dependent: :destroy
  has_one :charge, dependent: :destroy

  validates :nickname, presence: true, length: { maximum: 32 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }

  after_create :create_stripe_customer
  after_create :create_balance

  def stripe
    return @stripe if instance_variable_defined?(:@stripe)

    @stripe = stripe_id? ? Stripe::Customer.retrieve(stripe_id) : nil
  end

  protected

  def create_stripe_customer
    return if stripe_id?

    customer = Stripe::Customer.create(
      email: email,
      description: "User: #{id}"
    )
    update(stripe_id: customer.id)
  rescue Stripe::StripeError => e
    errors.add(:stripe, e.code.to_s.to_sym)
    throw :abort
  end

  def create_balance
    return if balance.present?

    build_balance(amount: 0)
    save!
  end
end
