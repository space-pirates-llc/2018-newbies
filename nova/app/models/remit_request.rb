# frozen_string_literal: true

class RemitRequest < ApplicationRecord
  belongs_to :user
  belongs_to :requested_user, class_name: 'User'

  validates :user_id, presence: true
  validates :requested_user_id, presence: true
  validates :amount, presence: true, numericality: { only_integer: true,
                                                     greater_than_or_equal_to: Constants::MIN_REMIT_AMOUNT,
                                                     less_than_or_equal_to: Constants::MAX_REMIT_AMOUNT, }

  validate :requested_user_should_be_different

  def accept!
    RemitService.execute!(self)
  end

  def reject!
    finalize_with_lock!(RemitRequestResult::RESULT_REJECTED)
  end

  def cancel!
    finalize_with_lock!(RemitRequestResult::RESULT_CANCELED)
  end

  # RemitRequestをRemitRequestResultに移す
  # 既にremit_requetに対してロックを獲得している時に使うメソッド
  # ロック獲得が必要であれば .finalize_with_lock! を用いること
  def finalize!(result)
    RemitRequestResult.create_from_remit_request!(self, result)
    destroy!
  end

  # lockを獲得しながらRemitRequestをRemitRequestResultに移す
  def finalize_with_lock!(result)
    ActiveRecord::Base.transaction do
      lock!
      finalize!(result)
    end
  end

  private

  def requested_user_should_be_different
    return if user != requested_user

    errors.add(:user, 'Cannot request a remit to yourself')
  end
end
