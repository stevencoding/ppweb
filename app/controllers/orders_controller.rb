class OrdersController < ApplicationController
  def new
    @event = Event.find_by_uid(params[:uid])
  end

  def checkout
    @event = Event.find_by_uid(params[:uid])

    current_user.bean = current_user.bean - @event.price.to_i * 10
    current_user.save

    owner = User.find(@event.user_id)
    owner.bean = owner.bean.to_i + @event.price.to_i * 10
    owner.save

    if @event.add_member(current_user)
      redirect_to event_path(uid: params[:uid]), notice: t("event.flashes.successfully_joined")
    else
      redirect_to event_path(uid: params[:uid]), notice: t("event.flashes.add_member_error")
    end
  end
end
