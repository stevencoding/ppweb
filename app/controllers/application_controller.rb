class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def redirect_to_target_or_default(default, *options)
    redirect_to(session[:return_to] || default, *options)
    session[:return_to] = nil
  end

  def login?
    !!current_user
  end

  def redirect_to_root_if_logged_in
    redirect_to root_url if logged_in?
  end

  def current_user
    @current_user ||= User.find_by_token(cookies[:token]) if cookies[:token]
  end
  helper_method :current_user
end
