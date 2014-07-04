class HomeController < ApplicationController
  before_filter :set_return_to, only: [:index]

  def index
    @events = Event.published.active(Time.zone.now).reverse
    if current_user
      @active_attended_events = current_user.attended_events.delete_if{ |e| e.start <= Time.zone.now }.sort_by(&:start)
    end
  end
end
