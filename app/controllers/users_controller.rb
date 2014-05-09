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

    black_list = %w(event create_login_seesion account blog signup login logout about admin api)

    user_name = @user.name

    if black_list.include? user_name
      flash[:notice] = "#{user_name} 是预留的名字"
      redirect_to :signup
      return
    end

    if User.exists? name: user_name
      flash[:notice] = "名字已占用"
      redirect_to :signup
      return
    end

    if User.exists? email: @user.email
      flash[:notice] = "邮箱已占用"
      redirect_to :signup
      return
    end

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
end
