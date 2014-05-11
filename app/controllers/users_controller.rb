#encoding: utf-8
class UsersController < ApplicationController
  before_filter :redirect_to_root_if_logged_in, only: [:signup, :login]
  before_filter :set_return_to, only: [:signup, :login, :show, :edit]

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
    @user = User.find_by_username(params[:username])
    redirect_to :root if @user.nil?
  end

  def edit
    @user = User.find_by_username(current_user.username) if logged_in?
    if @user.nil?
      redirect_to_target_or_default :root, :notice => "login first plz"
      return
    end
  end

  def update_username
    @user = User.find(current_user.id)
    @user.update_attributes(username: params[:user][:username])
    respond_to do |format|
      format.js
    end
  end

  def update_bio
    @user = current_user
    @user.update_attributes(bio: params[:user][:bio])
    respond_to do |format|
      format.js
    end
  end

  def update_email
    @user = current_user
    @user.update_attributes(email: params[:user][:email])
    respond_to do |format|
      format.js
    end
  end

  def update_role
    @user = current_user
    @user.update_attributes(role: params[:user][:role])
    respond_to do |format|
      format.js
    end
  end

  def set_locales
    if params[:locale]
      I18n.locale = cookies[:locale] = params[:locale]
      redirect_to_target_or_default :root
    end
  end
end
