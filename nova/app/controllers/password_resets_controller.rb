# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :set_user, only: %i[edit update]
  before_action :reset_request_validation, only: %i[edit update]

  def new
  end

  def create
    @user = User.find_by(email: password_reset_param[:email])

    if @user
      reset_token = SecureRandom.urlsafe_base64
      # 以下の処理が失敗することはないので、エラー処理は行なっていない
      @user.update_columns(reset_digest: BCrypt::Password.create(reset_token, cost: 10), reset_sent_at: Time.zone.now)

      # TODO: Redis 利用して deliver_later を使うか要相談
      UserMailer.password_reset(@user, @reset_token).deliver_now

      flash.now[:info] = "パスワードリセットのためのメールが送信されました"
      redirect_to login_path
    else
      flash.now[:danger] = "メールアドレスが見つかりません"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_password_param)
      # 一度利用した reset_digest はリセットする
      @user.update!(reset_digest: nil)

      flash.now[:success] = "パスワードが変更されました"
      redirect_to login_path
    else
      flash.now[:danger] = "不正なパスワードです"
      render 'edit', status: :bad_request
    end
  end

  private

  def password_reset_param
    params.require(:password_reset).fetch(:email)
  end

  def user_password_param
    params.require(:user_password).fetch(:password, :password_confirmation)
  end

  def set_user
    @user = User.find_by[email: params[:email]]
  end

  def reset_request_validation
    unless is_valid_reset_request?
      flash.now[:danger] = '不正なアドレスです'
      redirect_to login_path
    end
  end

  def is_valid_reset_request?
    @user && BCrypt::Password.new(@user.reset_digest).is_password?(params[:id]) && @user.reset_sent_at < 2.hours.ago
  end
end
