# frozen_string_literal: true

class RemitService
  class InsufficientBalanceError < StandardError; end

  class << self

    def execute!(remit_request)
      ActiveRecord::Base.transaction do
        user_balance = remit_request.user.balance
        requested_user_balance = remit_request.requested_user.balance

        # balanceの整合性を担保するため、悲観的ロックをかける
        aquire_lock!(user_balance, requested_user_balance)

        raise InsufficientBalanceError unless can_remit?(requested_user_balance, remit_request.amount)

        transfer_balance!(user_balance, requested_user_balance, remit_request.amount)
        finalize_remit_request!(remit_request)

        release_lock!(user_balance, requested_user_balance)
      end
    end

    def can_remit?(requested_user_balance, amount)
      requested_user_balance.can_withdraw?(amount)
    end

    def transfer_balance!(user_balance, requested_user_balance, amount)
      requested_user_balance.withdraw!(amount)
      user_balance.deposit!(amount)
    end

    def finalize_remit_request!(remit_request)
      RemitRequestResult.create_from_remit_request!(remit_request, RemitRequestResult::RESULT_ACCEPTED)
      remit_request.destroy!
    end

    def aquire_lock!(user_balance, requested_user_balance)
      user_balance.lock!
      requested_user_balance.lock!
    end

    def release_lock!(user_balance, requested_user_balance)
      user_balance.save!
      requested_user_balance.save!
    end
  end
end
