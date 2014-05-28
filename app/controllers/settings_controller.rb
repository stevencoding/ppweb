class SettingsController < ApplicationController
  before_filter :loggin_first_plz

  def payment
    @beans = @user.bean.blank? ? 0 : @user.bean
  end

  def profile
  end

  def freetime
    @freetime = @user.freetime
  end

  def update_profile
    @field = params[:field]
    @user = current_user
    @user.update_attributes(params[:user])
    respond_to do |format|
      format.js {
        render 'update_profile'
      }
    end
  end

  def update_bean
    bean = params[:bean].to_i * 10 if params[:bean]
    origin_bean = @user.bean.to_i
    total = bean + origin_bean
    if @user.update_attributes(bean: total)
      redirect_to set_payment_path, notice: t("transaction.suc_charged")
    end
  end

  def update_freetime
    @user.update_attributes(freetime: params[:freetime])
    redirect_to set_freetime_path, notice: t("transaction.suc_saved")
  end

  private

  def loggin_first_plz
    @user = User.find_by_username(current_user.username) if logged_in?
    if @user.nil?
      redirect_to_target_or_default :root, :notice => t("users.login_first_please")
      return
    end
  end
end
