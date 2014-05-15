class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.recent
  end
end
