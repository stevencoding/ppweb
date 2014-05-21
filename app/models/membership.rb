class Membership < ActiveRecord::Base
  attr_accessible :event_id, :event_member_id, :event_guest_id

  belongs_to :event
  belongs_to :event_member, class_name: "User"
  belongs_to :event_guest, class_name: "User"
end
