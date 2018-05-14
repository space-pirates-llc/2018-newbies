# frozen_string_literal: true

class Api::ChargesController < Api::ApplicationController
  def index
    @charges = current_user.charges.order(id: :desc).limit(50)

    render json: { amount: current_user.balance.amount, charges: @charges }
  end

  def create
    Balance.transaction do
      @charge = current_user.charges.create!(amount: params[:amount])
      current_user.balance.lock!
      current_user.balance.amount += params[:amount].to_i
      # #save! 時に validation が走り、変更処理後の金額が上限金額を超えていた場合
      # ActiveRecord::RecordInvalid error が発生し rescue 処理でレスポンスが行われる
      current_user.balance.save!
    end

    render json: @charge, status: :created
  rescue ActiveRecord::RecordInvalid => e
    record_invalid(e)
  end
end
