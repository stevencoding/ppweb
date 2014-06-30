class Message < ActiveRecord::Base
  attr_accessible :content, :receiver_id, :sender_id

  belongs_to :receiver, class_name: "User"
  belongs_to :sender, class_name: "User"

  has_many :notifications, as: :notifiable
end
