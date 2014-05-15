class HomeController < ApplicationController
  before_filter :set_return_to, only: [:index]

  def index
    @events = Event.all.reverse
  end
end
