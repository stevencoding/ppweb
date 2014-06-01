class MailPreview < MailView
  def start_event
    user = User.first
    event = Event.last
    NotificationMailer.start_event(user.id, event.id)
  end
end