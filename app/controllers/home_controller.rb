class HomeController < ApplicationController
  before_filter :set_return_to, only: [:index]

  def index
    @events = Event.where("published = true AND start >= :current_time", {current_time: Time.now.utc}).reverse
    @attended_events = current_user.attended_events.compact.sort_by(&:start) if current_user
  end
end
