class NotificationMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "no-reply@maodou.io"

  def start_event(user_id, event_id)
    @user = User.find user_id
    @event = Event.find event_id
    mail(to: @user.email, subject: "#{@event.title}")
  end
end
