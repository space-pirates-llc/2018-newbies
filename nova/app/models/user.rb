# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
  has_many :received_remit_requests, class_name: 'RemitRequest', foreign_key: :target_id, dependent: :destroy
  has_many :sent_remit_requests, class_name: 'RemitRequest', dependent: :destroy
  has_many :charges, dependent: :destroy
  has_one :credit_card, dependent: :destroy

  validates :nickname, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :create_stripe_customer

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
    pry.inspect
    errors.add(:stripe, e.code.to_s.to_sym)
    throw :abort
  end
end
