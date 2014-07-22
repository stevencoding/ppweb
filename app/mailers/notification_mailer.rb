# encoding: utf-8
class NotificationMailer < ActionMailer::Base
  include Resque::Mailer

  default from: %q('毛豆网' <hello@maodou.io>)

  def start_event(user_id, event_id)
    @user = User.find user_id
    @event = Event.find event_id
    mail(to: @user.email, subject: "#{@user.username}，毛豆网的活动还有30分开始")
  end
end
