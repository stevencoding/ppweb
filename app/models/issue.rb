class Issue < ActiveRecord::Base
  attr_accessible :content, :title, :user_id
  scope :recent, -> { order('id DESC') }

  belongs_to :user
  has_many :comments, as: 'commentable'
end
