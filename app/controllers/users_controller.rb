#encoding: utf-8
class UsersController < ApplicationController
  before_filter :redirect_to_root_if_logged_in, only: [:signup, :login]
  before_filter :set_return_to, only: [:signup, :show, :edit]

  def signup
    @user = User.new
  end

  def login
  end

  def create_login_session
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      cookies.permanent[:token] = user.token
      redirect_to_target_or_default :root
    else
      flash[:error] = t("users.invalid_email_or_pwd")
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
      UserMailer.welcome_email(@user.id).deliver
      cookies.permanent[:token] = @user.token
      redirect_to :root, :notice => t("users.successfully_signup")
    else
      render :signup
    end
  end

  def show
    @user = User.find_by_username(params[:username])
    redirect_to :root if @user.nil?
  end
end
