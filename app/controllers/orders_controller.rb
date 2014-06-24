class OrdersController < ApplicationController
  def new
    @event = Event.find_by_uid(params[:uid])
  end

  def checkout
    @event = Event.find_by_uid(params[:uid])
    if @event.add_member(current_user)
      redirect_to event_path(uid: params[:uid]), notice: t("event.flashes.successfully_joined")
    else
      redirect_to event_path(uid: params[:uid]), notice: t("event.flashes.add_member_error")
    end
  end
end
