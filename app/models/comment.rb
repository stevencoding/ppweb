class Comment < ActiveRecord::Base
  attr_accessible :content, :user_id
  belongs_to :event
  belongs_to :user
end
