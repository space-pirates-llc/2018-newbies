class Balance < ApplicationRecord
  belongs_to :user

  validates :amount, numericality: { greater_than: 0, less_than_or_equal_to: 100000, only_integer: true }, presence: true
end
