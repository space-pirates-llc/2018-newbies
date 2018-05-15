# frozen_string_literal: true

class Api::RemitRequestsController < Api::ApplicationController
  before_action :set_remit_request, only: %i[accept reject cancel]

  def index
    @sent_remit_requests = current_user.sent_remit_requests.send(params[:status] || 'outstanding').order(id: :desc).limit(50)
    @remit_requests = current_user.received_remit_requests.send(params[:status] || 'outstanding').order(id: :desc).limit(50)

    render json: { sent: @sent_remit_requests.as_json(include: :target), request: @remit_requests.as_json(include: :user) }
  end

  def create
    params[:emails].each do |email|
      user = User.find_by(email: email.downcase)
      next unless user

      RemitRequest.create!(user: current_user, target: user, amount: params[:amount])
    end

    render json: {}, status: :created
  end

  def accept
    Balance.transaction do
      sender = @remit_request.target
      receiver = @remit_request.user

      # 悲観的ロックを行う
      # ロックする順番をidの小さい順にすることでデットロックを回避する
      if sender.balance.id < receiver.balance.id
        sender.balance.lock!
        receiver.balance.lock!
      else
        receiver.balance.lock!
        sender.balance.lock!
      end

      # 残高の更新
      sender.balance.amount -= @remit_request.amount
      receiver.balance.amount += @remit_request.amount

      sender.balance.save!
      receiver.balance.save!

      # トランザクション処理の最後に
      # 当該 RemitRequest のステータスを変更する
      @remit_request.accepted!
    end

    render json: {}, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    @remit_request.errored!

    record_invalid(e)
  end

  def reject
    @remit_request.rejected!

    render json: {}, status: :ok
  end

  def cancel
    @remit_request.canceled!

    render json: {}, status: :ok
  end

  private

  def set_remit_request
    @remit_request = RemitRequest.find(params[:id])
  end
end
