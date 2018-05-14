class Balance < ApplicationRecord
  MIN_BALANCE_AMOUNT = 0
  MAX_BALANCE_AMOUNT = 100_000
  belongs_to :user

  validates :amount, numericality: { greater_than_or_equal_to: MIN_BALANCE_AMOUNT, less_than_or_equal_to: MAX_BALANCE_AMOUNT,only_integer: true }, presence: true
end
