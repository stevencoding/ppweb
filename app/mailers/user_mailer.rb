# encoding: utf-8
class UserMailer < ActionMailer::Base
  include Resque::Mailer

  default from: %q('毛豆网' <hello@maodou.io>)

  def welcome_email(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: "欢迎来到毛豆网")
  end

  def invite_guest_email(email, guest_name, sender_id, event_id)
    @sender = User.find sender_id
    @event = Event.find event_id
    @guest_name = guest_name
    mail(to: email, subject: "#{@guest_name}，来参加我组织的活动吧")
  end
end
