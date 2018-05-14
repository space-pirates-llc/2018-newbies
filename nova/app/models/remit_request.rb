# frozen_string_literal: true

class RemitRequest < ApplicationRecord
  belongs_to :user
  belongs_to :target, class_name: 'User'

  validates :amount, numericality: { greater_than: 0, only_integer: true }, presence: true
  validate :validate_equal_user_and_target
  validate :validate_nonexist_target
  enum status: { outstanding: 0, accepted: 1, rejected: 2, canceled: 3 }

  def is_outstanding?(at = Time.current)
    outstanding? && created_at <= at
  end

  def is_accepted?(at = Time.current)
    accepted? && updated_at <= at
  end

  def is_rejected?(at = Time.current)
    rejected? && updated_at <= at
  end

  def is_canceled?(at = Time.current)
    canceled? && updated_at <= at
  end

  private

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
end
