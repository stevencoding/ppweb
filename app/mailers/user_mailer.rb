# encoding: utf-8
class UserMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "no-reply@maodou.io"

  def welcome_email(user_id)
    @user = User.find user_id
    mail(to: "billiecoder@gmail.com", subject: "欢迎来到毛豆网")
  end

  def invite_guest_email(email, sender_id, event_id)
    @sender = User.find sender_id
    @event = Event.find event_id
    mail(to: email, subject: "#{@sender.username} 邀请您参加活动")
  end
end
