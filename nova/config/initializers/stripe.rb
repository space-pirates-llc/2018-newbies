# frozen_string_literal: true

require 'stripe'

stripe_config_path = Rails.root.join('config/stripe.yml')
stripe_config = YAML.safe_load(ERB.new(File.new(stripe_config_path).read).result, [], [], true)[Rails.env]

class << Stripe
  attr_accessor :public_key
end

Stripe.api_key = stripe_config['secret_key']
Stripe.public_key = stripe_config['public_key']
