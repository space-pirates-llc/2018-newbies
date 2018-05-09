# frozen_string_literal: true

class RemitRequest < ApplicationRecord
  belongs_to :user
  belongs_to :target, class_name: 'User'

  validates :amount, numericality: { greater_than: 0 }
  validates :user, presence: true
  validates :target, presence: true
  validate :validate_equal_user_and_target
  validate :validate_nonexist_target

  scope :outstanding, ->(at = Time.current) { not_accepted(at).not_rejected(at).not_canceled(at) }
  scope :accepted, ->(at = Time.current) { where(RemitRequest.arel_table[:accepted_at].lteq(at)) }
  scope :not_accepted, ->(at = Time.current) { where(accepted_at: nil).or(where(RemitRequest.arel_table[:accepted_at].gt(at))) }
  scope :rejected, ->(at = Time.current) { where(RemitRequest.arel_table[:rejected_at].lteq(at)) }
  scope :not_rejected, ->(at = Time.current) { where(rejected_at: nil).or(where(RemitRequest.arel_table[:rejected_at].gt(at))) }
  scope :canceled, ->(at = Time.current) { where(RemitRequest.arel_table[:canceled_at].lteq(at)) }
  scope :not_canceled, ->(at = Time.current) { where(canceled_at: nil).or(where(RemitRequest.arel_table[:canceled_at].gt(at))) }

  def validate_equal_user_and_target
    if user.email == target.email
      errors.add(:base, "自分宛にリクエストは作成できません。")
    end
  end

  def validate_nonexist_target
    if User.where(email: target.email).blank?
      errors.add(:base, "登録されていないユーザーです。")
    end
  end

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
end
