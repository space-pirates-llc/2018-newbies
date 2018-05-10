module SessionsHelper

  # Logs the given user
  def log_in(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end