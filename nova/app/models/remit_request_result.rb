# frozen_string_literal: true

class RemitRequestResult < ApplicationRecord
  RESULT_ACCEPTED = 'accepted'
  RESULT_REJECTED = 'rejected'
  RESULT_CANCELED = 'canceled'
  MIN_REMIT_AMOUNT = 1 # TODO: RemitRequestと共通化
  MAX_REMIT_AMOUNT = 99_999_999 # TODO: RemitRequestと共通化

  belongs_to :user
  belongs_to :requested_user, class_name: 'User'

  validates :amount, presence: true, numericality: { only_integer: true,
                                                     greater_than_or_equal_to: MIN_REMIT_AMOUNT,
                                                     less_than_or_equal_to: MAX_REMIT_AMOUNT, }
  validates :result, presence: true,
                     inclusion: { in: [RESULT_ACCEPTED, RESULT_REJECTED, RESULT_CANCELED] }

  scope :accepted, -> { where(result: RESULT_ACCEPTED) }
  scope :rejected, -> { where(result: RESULT_REJECTED) }
  scope :canceled, -> { where(result: RESULT_CANCELED) }

  def self.create_from_remit_request!(remit_request, result)
    create!(user: remit_request.user,
            requested_user: remit_request.requested_user,
            amount: remit_request.amount,
            result: result)
  end
end
