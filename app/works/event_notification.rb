class EventNotification
  @queue = 'notification'

  def self.perform(event_id)
    event = Event.find event_id
    if event.all_members.present?
      event.all_members.each do |m|
        Notification.notify("start", event.user, m, event)
        NotificationMailer.start_event(m.id, event.id).deliver
      end
    end
  end
end
