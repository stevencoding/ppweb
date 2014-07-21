class Comment < ActiveRecord::Base
  attr_accessible :content, :commentable_id, :commentable_type, :user_id
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true
end
