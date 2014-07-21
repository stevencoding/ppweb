class Blog < ActiveRecord::Base
  attr_accessible :content, :title, :user_id, :name
  scope :recent, -> { order('id DESC') }

  belongs_to :user
  has_many :comments, as: 'commentable'

  def to_param
  # blog_path(@blog), will become blog/0112-good-news
    "#{id} #{name}".parameterize
  end
end
