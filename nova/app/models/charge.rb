# frozen_string_literal: true

class Charge < ApplicationRecord
  belongs_to :user

  validates :amount, numericality: { greater_then: 0 }

  after_create :create_stripe_charge

  def finalize
    # TODO: Check charge's status to avoid duplicate charges

    ActiveRecord::Base.transaction do
      lock!
      user.balance.amount += amount
      user.balance.save!

      # TODO: Update charge's status

      save!
    end
  end

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
