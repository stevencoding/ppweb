class Event < ActiveRecord::Base
  attr_accessible :description, :start, :title, :user_id, :uid, :price, :published

  before_create { generate_uid(:uid) }
  after_create :send_notification_to_site_users

  belongs_to :user
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :event_member
  has_many :guests, through: :memberships, source: :event_guest

  has_many :notifications, as: :notifiable

  def generate_uid(column)
    begin
      self[column] = ('0'..'9').to_a.sample(8).join
    end while Event.exists?(column => self[column])
  end

  def add_member(member)
    return false if self.user == member
    return false if self.members.include?(member)
    self.members << member
    Notification.notify("join", member, self.user, self)
  end

  def all_members
    (self.members + self.guests).uniq
  end

  def send_notification_to_site_users
    User.all.each do |u|
      Notification.notify("create", self.user, u, self) if u.id != self.user.id
    end
  end
end
