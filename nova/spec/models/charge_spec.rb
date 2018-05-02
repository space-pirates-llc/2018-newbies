# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Charge, type: :model do
  subject(:charge) { build(:charge) }

  it { is_expected.to be_valid }
end
