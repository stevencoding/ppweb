class MailPreview < MailView
  def start_event
    user = User.first
    event = Event.last
    NotificationMailer.start_event(user.id, event.id)
  end

  def welcome_user
    user = User.first
    UserMailer.welcome_email(user.id)
  end

  def invite_guest
    user = User.first
    event = Event.first
    UserMailer.invite_guest_email("maodou@maodou.io", "maodou", user.id, event.id)
  end
end
