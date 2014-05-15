class NotificationsController < ApplicationController
  before_filter :set_return_to, only: [:index]
  after_filter :mark_read

  def index
    @notifications = current_user.notifications.recent
  end

  private
  def mark_read
    current_user.notifications.update_all(unread: false)
  end
end
