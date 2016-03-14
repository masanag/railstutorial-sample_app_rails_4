#
module SessionsHelper
  def sign_in(user)
    remenber_token = User.new_remember_token
    cookies.permanent[:remenber_token] = remenber_token
    user.update_attribute(:remenber_token, User.encrypt(remenber_token))
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remenber_token = User.encrypt(cookies[:remenber_token])
    @current_user ||= User.find_by(remember_token: remenber_token)
  end
end
