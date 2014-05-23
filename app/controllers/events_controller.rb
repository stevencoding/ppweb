class EventsController < ApplicationController
  before_filter :find_event, only: [:show, :event_membership, :invitation]
  before_filter :set_return_to, only: [:show, :new]
  before_filter :check_owner, only: [:invitation, :invite_guest, :delete_guest, :edit, :update_event]

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

  def edit
    @event = Event.find_by_uid(params[:uid])
  end

  def update
    @event = Event.find_by_uid(params[:uid])
    @event.update_attributes(params[:event])
    if @event.save
      redirect_to account_path(@event.user.username)
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
    Notification.notify("invite", @event.user, @member, @event)
    respond_to do |format|
      format.js
    end
  end

  def delete_guest
    @member = User.find_by_username(params[:guest])
    @event = Event.find_by_uid(params[:uid])
    @event.guests.delete(@member)
    respond_to do |format|
      format.js
    end
  end

  def update_event
    @field = params[:field]
    @event = Event.find_by_uid(params[:uid])
    @event.update_attributes(params[:event])
    respond_to do |format|
      format.js {
        render 'update_event'
      }
    end
  end

  private

  def find_event
    @event = Event.find_by_uid(params[:uid])
  end

  def check_owner
    if current_user.nil?
      redirect_to_target_or_default :root, notice: t("users.login_first_please")
      return
    end
    if Event.find_by_uid(params[:uid]).user != current_user
      redirect_to_target_or_default :root, notice: t("no_authorized")
      return
    end
  end
end
