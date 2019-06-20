# frozen_string_literal: true

class Api::ChargeHistoriesController < Api::ApplicationController
  def index
    @charge_histories = current_user.charge_histories.order(id: :desc).limit(50)

    render json: { charges: @charge_histories }
  end
end
