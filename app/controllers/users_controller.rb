#encoding: utf-8
class UsersController < ApplicationController
  before_filter :redirect_to_root_if_logged_in, only: [:signup, :login]

  def welcome
  end

  def signup
    @user = User.new
  end

  def login
  end

  def create_login_session
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      cookies.permanent[:token] = user.token
      redirect_to root_url
    else
      flash[:error] = "无效的邮箱或密码"
      redirect_to :login
    end
  end

  def logout
    cookies.delete(:token)
    redirect_to root_url
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      cookies.permanent[:token] = @user.token
      redirect_to :root, :notice => "注册成功"
    else
      render :signup
    end
  end

  def show
    @user = User.find_by_name(params[:name])
    redirect_to :root if @user.nil?
  end

  def edit
    @user = User.find_by_name(current_user.name) if current_user
    if @user.nil?
      redirect_to_target_or_default :root, :notice => "login first plz"
      return
    end
  end

  def update
    respond_to do |format|
      if current_user.update_attributes(params[:user])
        format.html { redirect_to account_path(current_user.name), :notice => "user info updated" }
      end
    end
  end

  def set_locales
    if params[:locale]
      I18n.locale = cookies[:locale] = params[:locale]
      redirect_to :root
    end
  end
end
