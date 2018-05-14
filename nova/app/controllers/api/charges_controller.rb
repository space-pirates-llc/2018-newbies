# frozen_string_literal: true

class Api::ChargesController < Api::ApplicationController
  def index
    @charges = current_user.charges.order(id: :desc).limit(50)

    render json: { amount: current_user.balance.amount, charges: @charges }
  end

  def create
    if current_user.balance.amount + params[:amount] > Balance::MAX_BALANCE_AMOUNT
      render json: current_user.charges.new(amount: params[:amount]), status: :unprocessable_entity
    else
      Balance.transaction do
        @charge = current_user.charges.create!(amount: params[:amount])
        current_user.balance.lock!
        current_user.balance.amount += params[:amount].to_i
        current_user.balance.save!
      end

      render json: @charge, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    record_invalid(e)
  end
end
