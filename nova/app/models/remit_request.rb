# frozen_string_literal: true

class RemitRequest < ApplicationRecord
  class InsufficientBalanceError < StandardError; end

  belongs_to :user
  belongs_to :target, class_name: 'User'

  validates :amount, numericality: { greater_then: 0 }

  scope :outstanding, ->(at = Time.current) { not_accepted(at).not_rejected(at).not_canceled(at) }
  scope :accepted, ->(at = Time.current) { where(RemitRequest.arel_table[:accepted_at].lteq(at)) }
  scope :not_accepted, ->(at = Time.current) { where(accepted_at: nil).or(where(RemitRequest.arel_table[:accepted_at].gt(at))) }
  scope :rejected, ->(at = Time.current) { where(RemitRequest.arel_table[:rejected_at].lteq(at)) }
  scope :not_rejected, ->(at = Time.current) { where(rejected_at: nil).or(where(RemitRequest.arel_table[:rejected_at].gt(at))) }
  scope :canceled, ->(at = Time.current) { where(RemitRequest.arel_table[:canceled_at].lteq(at)) }
  scope :not_canceled, ->(at = Time.current) { where(canceled_at: nil).or(where(RemitRequest.arel_table[:canceled_at].gt(at))) }

  def outstanding?(at = Time.current)
    !accepted?(at) && !rejected?(at) && !canceled?(at)
  end

  def accepted?(at = Time.current)
    accepted_at && accepted_at <= at
  end

  def rejected?(at = Time.current)
    rejected_at && rejected_at <= at
  end

  def canceled?(at = Time.current)
    canceled_at && canceled_at <= at
  end

  def accept!
    ActiveRecord::Base.transaction do
      user.balance.lock!

      raise InsufficientBalanceError unless user.balance.can_withdraw?(amount)

      user.balance.withdraw!(amount)
      target.balance.deposit!(amount)

      RemitRequestResult.create_from_remit_request!(self, RemitRequestResult::RESULT_ACCEPTED)
      destroy!

      user.balance.save!
    end
  end

  def reject!
    ActiveRecord::Base.transaction do
      RemitRequestResult.create_from_remit_request!(self, RemitRequestResult::RESULT_REJECTED)
      destroy!
    end
  end

  def cancel!
      RemitRequestResult.create_from_remit_request!(self, RemitRequestResult::RESULT_CANCELED)
      destroy!
  end
end
