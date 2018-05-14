# frozen_string_literal: true

class RemitRequest < ApplicationRecord
  belongs_to :user
  belongs_to :requested_user, class_name: 'User'

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
    RemitService.execute!(self)
  end

  def reject!
    finalize_with_lock!(RemitRequestResult::RESULT_REJECTED)
  end

  def canceled!
    finalize_with_lock!(RemitRequestResult::RESULT_CANCELED)
  end

  # RemitRequestをRemitRequestResultに移す
  # 既にremit_requetに対してロックを獲得している時に使うメソッド
  # 獲得していなければ .finalize_with_lock! を用いる
  def finalize!(result)
    RemitRequestResult.create_from_remit_request!(self, result)
    destroy!
  end

  # lockを獲得しながらRemitRequestをRemitRequestResultに移す
  def finalize_with_lock!(result)
    ActiveRecord::Base.transaction do
      lock!
      finalize!(result)
      save!
    end
  end
end
