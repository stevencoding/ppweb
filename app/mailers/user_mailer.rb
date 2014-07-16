# encoding: utf-8
class UserMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "no-reply@maodou.io"

  def welcome_email(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: "欢迎来到毛豆网")
  end
end
