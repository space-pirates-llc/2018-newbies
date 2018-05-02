# frozen_string_literal: true

require 'stripe'

class << Stripe
  attr_accessor :public_key
end

stripe_config = Rails.application.config_for(:stripe)

Stripe.api_key = stripe_config['secret_key']
Stripe.public_key = stripe_config['public_key']
