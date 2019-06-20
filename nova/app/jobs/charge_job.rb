class ChargeJob < ApplicationJob
  queue_as :default

  def perform(charge)
    #raise Stripe::CardError.new("hoge", {}, :missing)
    #raise Stripe::InvalidRequestError.new("hoge", {})
    #raise Stripe::APIConnectionError.new()

    capture_response = Stripe::Charge.retrieve(charge.stripe_id).capture
    execute!(charge, 'charged')

  rescue Stripe::CardError => e
    # Since it's a decline, Stripe::CardError will be caught
    execute!(charge, 'faild')

  rescue Stripe::InvalidRequestError => e
    # Invalid parameters were supplied to Stripe's API
    execute!(charge, 'invalid request')

  rescue => e
   puts "-----"
   puts "Retry Job"
   throw e
  end

  def execute!(charge, result) 
    ActiveRecord::Base.transaction do
      if charge.present?
        user_balance = charge.user.balance
      else
        return
      end

      if result == 'charged'
        # captureが成功した場合balanceを増やす
        # transactionが終了するとlockは解放される
        aquire_lock!(user_balance)
        increase_balance!(user_balance, charge.amount)
      end

      #add charge_history into charge_history table
      ChargeHistory.create!(amount: charge.amount, stripe_id: charge.stripe_id, result: result, user_id: charge.user_id)

      #delete charge clomun 
      charge.destroy!
    end
  end

  def increase_balance!(user_balance, amount)
    user_balance.deposit!(amount)
  end

  # balanceの整合性を担保するため悲観的行ロックを獲得する
  def aquire_lock!(balance)
    balance.lock!
  end

end
