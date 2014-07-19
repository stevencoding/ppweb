class Issue < ActiveRecord::Base
  attr_accessible :content, :title, :user_id
  belongs_to :user
  scope :recent, -> { order('id DESC') }
end
