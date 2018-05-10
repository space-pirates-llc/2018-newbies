class Balance < ApplicationRecord
  MIN_BALANCE_AMOUNT = 0
  MAX_BALANCE_AMOUNT = 99_999_999

  belongs_to :user

  validates :amount, presence: true, numericality: { only_integer: true,
                                                     greater_than_or_equal_to: MIN_BALANCE_AMOUNT,
                                                     less_than_or_equal_to: MAX_BALANCE_AMOUNT }

  def can_withdraw?(withdrawal_amount)
    withdrawal_amount <= amount
  end

  def withdraw!(withdrawal_amount)
    self.amount -= withdrawal_amount
    save!
  end

  def deposit!(deposit_amount)
    self.amount += deposit_amount
    save!
  end
end
