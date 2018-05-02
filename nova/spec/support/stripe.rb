# frozen_string_literal: true

module StripeHelper
  extend ActiveSupport::Concern

  included do
    let(:stripe) { StripeMock.create_test_helper }

    before(:each) do
      StripeMock.start
    end

    after(:each) do
      StripeMock.stop
    end
  end
end

RSpec.configure do |config|
  config.include(StripeHelper)
end
