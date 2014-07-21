# encoding: utf-8
class NotificationMailer < ActionMailer::Base
  include Resque::Mailer

  default from: (Mail::Encodings.b_value_encode '毛豆网 ', 'UTF-8').to_s  + '<hello@maodou.io>'

  def start_event(user_id, event_id)
    @user = User.find user_id
    @event = Event.find event_id
    mail(to: @user.email, subject: "#{@event.title}")
  end
end
