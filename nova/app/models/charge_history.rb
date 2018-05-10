class ChargeHistory < ApplicationRecord
  belongs_to :user

  MIN_CHARGE_AMOUNT = 0
  MAX_CHARGE_AMOUNT = 99_999_999

  validates :amount, presence: true, numericality: { only_integer: true,
                                                   greater_than_or_equal_to: MIN_CHARGE_AMOUNT,
                                                   less_than_or_equal_to: MAX_CHARGE_AMOUNT }
end
