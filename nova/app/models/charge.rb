# frozen_string_literal: true

class Charge < ApplicationRecord
  belongs_to :user

  validates :amount, numericality: { greater_than: 0, only_integer: true }

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
