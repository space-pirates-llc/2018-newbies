class Balance < ApplicationRecord
  MIN_BALANCE_AMOUNT = 0
  MAX_BALANCE_AMOUNT = 99_999_999

  belongs_to :user

  validates :amount, presence: true, numericality: { only_integer: true,
                                                     greater_than_or_equal_to: MIN_BALANCE_AMOUNT,
                                                     less_than_or_equal_to: MAX_BALANCE_AMOUNT }
end
