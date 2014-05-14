class Membership < ActiveRecord::Base
  attr_accessible :event_id, :event_member_id

  belongs_to :event
  belongs_to :event_member, class_name: "User"
end
