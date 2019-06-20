# frozen_string_literal: true

class Api::ChargesController < Api::ApplicationController
  def index
    if current_user.charge.present?
      @charge = [current_user.charge]
    else
      @charge = []
    end

    render json: { charges: @charge }
  end

  def create
    ActiveRecord::Base.transaction do
      @charge = current_user.create_charge!(amount: params[:amount])
      ChargeJob.set(wait: 3.seconds).perform_later(@charge)
      render json: @charge, status: :created
    end
  end
end
