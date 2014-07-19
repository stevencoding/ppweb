class Blog < ActiveRecord::Base
  attr_accessible :content, :title, :user_id, :name
  belongs_to :user
  scope :recent, -> { order('id DESC') }

  def to_param
  # blog_path(@blog), will become blog/0112-good-news
    "#{id} #{name}".parameterize
  end
end
