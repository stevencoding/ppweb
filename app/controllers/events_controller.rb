class EventsController < ApplicationController
  before_filter :find_event, only: [:show, :event_membership, :invitation]
  before_filter :set_return_to, only: [:show, :new]

  autocomplete :user, :username

  def new
    @event = current_user.events.new
  end

  def show
  end

  def create
    @event = current_user.events.new(params[:event])
    if @event.save
      redirect_to account_path(current_user.username)
    end
  end

  def event_membership
    if @event.add_member(current_user)
      redirect_to event_path(uid: params[:uid]), notice: t("event.flashes.successfully_joined")
    else
      redirect_to event_path(uid: params[:uid]), notice: t("event.flashes.add_member_error")
    end
  end

  def invitation
    @guests = @event.guests
  end

  def invite_guest
    @member = User.find_by_username(params[:guest])
    @event = Event.find_by_uid(params[:uid])
    if @event.user.id == @member.id
      @author_flag = true
      return
    end
    if @event.guests.include?(@member)
      @guest_flag = true
      return
    end
    @event.guests << @member
    respond_to do |format|
      format.js
    end
  end

  private

  def find_event
    @event = Event.find_by_uid(params[:uid])
  end
end
