# frozen_string_literal: true

class RemitRequestResult < ApplicationRecord
  RESULT_ACCEPTED = 'accepted'
  RESULT_REJECTED = 'rejected'
  RESULT_CANCELED = 'canceled'

  belongs_to :user
  belongs_to :requested_user, class_name: 'User'

  validates :user_id, presence: true
  validates :requested_user_id, presence: true
  validates :amount, presence: true, numericality: { only_integer: true,
                                                     greater_than_or_equal_to: Constants::MIN_REMIT_AMOUNT,
                                                     less_than_or_equal_to: Constants::MAX_REMIT_AMOUNT, }
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
