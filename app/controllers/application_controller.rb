class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :init

  private

  def init
    set_locale_to_zh
  end

  def set_locale_to_zh
    I18n.locale = cookies[:locale] || "zh-CN"
  end

  def redirect_to_target_or_default(default, *options)
    redirect_to(session[:return_to] || default, *options)
    session[:return_to] = nil
  end

  def logged_in?
    !!current_user
  end
  helper_method :logged_in?

  def redirect_to_root_if_logged_in
    redirect_to root_url if logged_in?
  end

  def current_user
    @current_user ||= User.find_by_token(cookies[:token]) if cookies[:token]
  end
  helper_method :current_user
end
