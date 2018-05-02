# frozen_string_literal: true

class CreditCard < ApplicationRecord
  attr_accessor :source

  belongs_to :user

  validates :stripe, presence: true
  validates :brand, presence: true
  validates :last4, presence: true
  validates :exp_year, numericality: true
  validates :exp_month, numericality: true

  before_validation :create_stripe_card
  after_create :update_stripe_card

  def stripe
    return @stripe if instance_variable_defined?(:@stripe)

    @stripe = stripe_id? ? user.stripe.sources.retrieve(stripe_id) : nil
  end

  protected

  def create_stripe_card
    return if stripe_id?

    card = user.stripe.sources.create(source: source)
    assign_attributes(
      stripe_id: card.id,
      brand: card.brand,
      last4: card.last4,
      exp_year: card.exp_year,
      exp_month: card.exp_month
    )
  rescue Stripe::StripeError => e
    errors.add(:source, e.code.to_s.to_sym)
    throw :abort
  end

  def update_stripe_card
    stripe.metadata = {
      credit_card_id: id,
    }

    stripe.save
  end
end
