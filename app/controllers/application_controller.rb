class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :init
  before_filter :set_locale

  private

  def init
    set_locale_to_zh
    count_unread_notification
  end

  def set_locale
    if params[:locale]
      I18n.locale = cookies[:locale] = params[:locale]
    end
  end

  def set_return_to
    session[:return_to] = request.url
  end

  def set_locale_to_zh
    I18n.locale = cookies[:locale] || "zh-CN"
  end

  def redirect_to_target_or_default(default, *options)
    redirect_to(session[:return_to] || default, *options)
    session[:return_to] = nil
  end

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  def render_optional_error_file(status_code)
    status = status_code.to_s
    if ["404","403", "422", "500"].include?(status)
      render :template => "/errors/#{status}", :format => [:html], :handler => [:erb], :status => status, :layout => "application"
    else
      render :template => "/errors/unknown", :format => [:html], :handler => [:erb], :status => status, :layout => "application"
    end
  end

  def logged_in?
    !!current_user
  end
  helper_method :logged_in?

  def redirect_to_root_if_logged_in
    redirect_to root_url if logged_in?
  end

  def redirect_to_target_or_default(default, *options)
    redirect_to(session[:return_to] || default, *options)
    session[:return_to] = nil
  end

  def current_user
    @current_user ||= User.find_by_token(cookies[:token]) if cookies[:token]
  end
  helper_method :current_user

  def count_unread_notification
    @unread_count = current_user ? current_user.notifications.where(:unread => true).count : 0
  end
end
