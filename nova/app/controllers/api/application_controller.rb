# frozen_string_literal: true

class Api::ApplicationController < ActionController::API
  ENDPOINT_SCHEME = 'http' # TODO: 設定値にする

  include AbstractController::Translation

  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :required_login!
  before_action :verify_request_from_same_origin

  protected

  def required_login!
    render(json: { errors: [t('api.application.errors.unauthorized')] }, status: :unauthorized) unless user_signed_in?
  end

  # `/api` に対するCSRFを防ぐために、リクエスト先のHostとOriginが一致するかをチェックする
  # novaの画面からリクエストされたアクセスのみを許可する。
  def verify_request_from_same_origin
    source_origin = request.origin || request.referer
    target_origin = request.headers['Host'] # port 情報も合わせて取得するためにheadersに直接アクセスする

    if source_origin && target_origin
      source = URI.parse(source_origin)
      target = URI.parse("#{ENDPOINT_SCHEME}://#{target_origin}")
      return if source.scheme == target.scheme && source.host == target.host && source.port == target.port
    end

    render json: { errors: ["cross site request is not allowed"] }, status: :forbidden
  end

  def record_invalid(exception)
    errors = exception.record.errors.full_messages

    render json: { errors: errors }, status: :unprocessable_entity
  end

  def record_not_found(exception)
    render json: { errors: [exception.message] }, status: :not_found
  end

  def parameter_missing(exception)
    render json: { errors: [exception.message] }, status: :unprocessable_entity
  end
end
