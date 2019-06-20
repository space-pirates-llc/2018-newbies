# frozen_string_literal: true

class Api::RemitRequestsController < Api::ApplicationController
  before_action :exists_remit_request, only: %i[accept reject cancel]
  before_action :correct_user, only: %i[accept reject cancel]

  def index
    @remit_requests = current_user.received_remit_requests.preload(:user).order(id: :desc).limit(50)

    render json: @remit_requests.as_json(include: :user)
  end

  def create
    params[:emails].each do |email|
      requested_user = User.find_by(email: email)
      next unless requested_user

      RemitRequest.create!(user: current_user, requested_user: requested_user, amount: params[:amount])
    end

    render json: {}, status: :created
  end

  def accept
    remit_request.accept!

    render json: {}, status: :ok
  rescue RemitService::InsufficientBalanceError
    render json: { errors: ['Insufficient balance'] }, status: :bad_request
  end

  def reject
    remit_request.reject!

    render json: {}, status: :ok
  end

  def cancel
    remit_request.cancel!

    render json: {}, status: :ok
  end

  private

  def exists_remit_request
    render json: {}, status: :not_found unless remit_request
  end

  def correct_user
    render json: {}, status: :forbidden unless remit_request.requested_user == current_user
  end

  def remit_request
    @remit_request ||= RemitRequest.find(params[:id])
  end
end
