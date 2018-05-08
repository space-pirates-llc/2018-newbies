# frozen_string_literal: true

class UserMailer < ApplicarionMailer
  def password_reset(user, reset_token)
    @user = user
    @reset_token = reset_token
    mail to: user.email, subject: "Password reset"
  end
end
