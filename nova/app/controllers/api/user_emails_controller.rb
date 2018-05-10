class Api::UserEmailsController < Api::ApplicationController
  def create
    if user_email_exists?(params[:email])
      render json: {}
    else
      render json: { error: 'Not found'}, status: :not_found
    end
  end

  private

  def user_email_exists?(email)
    User.where(email: email).exists?
  end
end
