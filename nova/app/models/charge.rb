# frozen_string_literal: true

class Charge < ApplicationRecord
  MIN_CHARGE_AMOUNT = 0
  MAX_CHARGE_AMOUNT = 100_000

  belongs_to :user

  validates :amount, numericality: { greater_than_or_equal_to: MIN_CHARGE_AMOUNT, less_than_or_equal_to: MAX_CHARGE_AMOUNT, only_integer: true }, presence: true

  after_create :create_stripe_charge

  protected

  def create_stripe_charge
    Stripe::Charge.create(
      amount: amount,
      currency: 'jpy',
      customer: user.stripe_id
    )
  rescue Stripe::StripeError => e
    errors.add(:user, e.code.to_s.to_sym)
    throw :abort
  end
end
