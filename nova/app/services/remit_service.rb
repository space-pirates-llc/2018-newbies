# frozen_string_literal: true

class RemitService
  class InsufficientBalanceError < StandardError; end

  class << self

    def execute!(remit_request)
      ActiveRecord::Base.transaction do
        # balanceの整合性を担保するため、悲観的ロックをかける
        aquire_lock!(user_balance, target_balance)

        user_balance = remit_request.user.balance
        target_balance = remit_request.target.balance

        raise InsufficientBalanceError unless can_remit?(user_balance, remit_request.amount)

        transfer_balance!(user_balance, target_balance, remit_request.amount)
        finalize_remit_request!(remit_request)

        release_lock!(user_balance, target_balance)
      end
    end

    def can_remit?(user_balance, amount)
      user_balance.can_withdraw?(amount)
    end

    def transfer_balance!(user_balance, target_balance, amount)
      user_balance.withdraw!(amount)
      target_balance.deposit!(amount)
    end

    def finalize_remit_request!(remit_request)
      RemitRequestResult.create_from_remit_request!(remit_request, RemitRequestResult::RESULT_ACCEPTED)
      remit_request.destroy!
    end

    def aquire_lock!(user_balance, target_balance)
      user_balance.lock!
      target_balance.lock!
    end

    def release_lock!(user_balance, target_balance)
      user_balance.save!
      target_balance.save!
    end
  end
end
