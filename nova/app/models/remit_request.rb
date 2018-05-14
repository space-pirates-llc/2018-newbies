# frozen_string_literal: true

class RemitRequest < ApplicationRecord
  belongs_to :user
  belongs_to :requested_user, class_name: 'User'

  validates :amount, numericality: { greater_then: 0 }

  def accept!
    RemitService.execute!(self)
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
