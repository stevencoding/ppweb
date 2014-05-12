class Event < ActiveRecord::Base
  attr_accessible :description, :start_at, :title, :user_id, :uid, :price
  before_create { generate_uid(:uid) }

  belongs_to :user

  def generate_uid(column)
    begin
      self[column] = ('0'..'9').to_a.sample(8).join
    end while Event.exists?(column => self[column])
  end
end
