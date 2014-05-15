class Notification < ActiveRecord::Base
  attr_accessible :action, :sender, :receiver, :unread, :notifiable

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :recent, order("created_at DESC")

  def self.notify(action, sender, receiver, unread = true, notifiable)
    n = Notification.new receiver: receiver, notifiable: notifiable
    n.action = action
    n.unread = unread
    n.sender = sender
    n.save
  end
end
