# frozen_string_literal: true

class Api::ChargesController < Api::ApplicationController
  def index
    @charges = current_user.charges.order(id: :desc).limit(50)

    render json: { amount: current_user.balance.amount, charges: @charges }
  end

  def create
    @charge = current_user.charges.create!(amount: params[:amount])
    current_user.lock!
    current_user.balance.amount += params[:amount]
    current_user.balance.save
    render json: @charge, status: :created
  rescue ActiveRecord::RecordInvalid => e
    record_invalid(e)
  end
end
