# frozen_string_literal: true

class Api::ApplicationController < ActionController::API
  include AbstractController::Translation

  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  before_action :required_login!

  protected

  def required_login!
    render(json: { errors: [t('api.application.errors.unauthorized')] }, status: :unauthorized) unless user_signed_in?
  end

  def record_invalid(exception)
    errors = exception.record.errors.full_messages

    render json: { errors: errors }, status: :unprocessable_entity
  end

  def parameter_missing(exception)
    render json: { errors: [exception.message] }, status: :unprocessable_entity
  end
end
