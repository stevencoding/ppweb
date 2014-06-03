class EventNotification
  @queue = 'notification'

  def self.perform(event_id)
    event = Event.find event_id
    attender = event.all_members << event.user
    attender.each do |m|
      Notification.notify("start", event.user, m, event)
      NotificationMailer.start_event(m.id, event.id).deliver
    end
  end
end
