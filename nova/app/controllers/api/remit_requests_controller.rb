# frozen_string_literal: true

class Api::RemitRequestsController < Api::ApplicationController
  def index
    @remit_requests = current_user.received_remit_requests.page(params[:page])
    pages = current_user.received_remit_requests.count / 10 + 
      ( current_user.received_remit_requests.count % 10 ? 1 : 0)
    render json:{max_pages: pages, remit_requests: @remit_requests.as_json(include: :user).to_a}
  end

  def create
    params[:emails].each do |email|
      user = User.find_by(email: email)
      next unless user

      RemitRequest.create!(user: current_user, target: user, amount: params[:amount])
    end

    render json: {}, status: :created
  end

  def accept
    @remit_request = RemitRequest.find(params[:id])
    @remit_request.update!(accepted_at: Time.now)

    render json: {}, status: :ok
  end

  def reject
    @remit_request = RemitRequest.find(params[:id])
    @remit_request.update!(rejected_at: Time.now)

    render json: {}, status: :ok
  end

  def cancel
    @remit_request = RemitRequest.find(params[:id])
    @remit_request.update!(canceled_at: Time.now)

    render json: {}, status: :ok
  end
end
