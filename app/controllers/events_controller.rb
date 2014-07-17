class EventsController < ApplicationController
  before_filter :find_event, only: [:show, :event_membership, :invitation]
  before_filter :set_return_to, only: [:show, :new]
  before_filter :check_owner, only: [:invitation, :invite_guest, :delete_guest, :edit, :update_event, :invite_guest_by_mail]

  autocomplete :user, :username

  def index
    @events = Event.where(published: true).reverse
  end

  def new
    @event = current_user.events.new
  end

  def show
    if @event.blank?
      render_404
    elsif @event.published || @event.user == current_user || @event.guests.include?(current_user)
      render :show
    else
      render_403
    end
  end

  def create
    @event = current_user.events.new(params[:event])
    if @event.save
      timestamp = @event.start - 0.5.hour
      if timestamp > Time.zone.now
        Resque.enqueue_at(timestamp, EventNotification, @event.id)
      end
      redirect_to account_path(current_user.username)
    end
  end

  def edit
    @event = Event.find_by_uid(params[:uid])
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

  def invite_guest_by_mail
    event = Event.find_by_uid(params[:uid])
    UserMailer.invite_guest_email(params[:email], current_user.id, event.id).deliver
    redirect_to event_invitation_path, notice: "Email was sent successfully!"
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
    old_stamp = @event.start - 0.5.hour
    @event.update_attributes(params[:event])
    new_stamp = @event.start - 0.5.hour
    if old_stamp != new_stamp
      Resque.remove_delayed_job_from_timestamp(old_stamp, EventNotification, @event.id)
      if new_stamp > Time.zone.now
        Resque.enqueue_at(new_stamp, EventNotification, @event.id)
      end
    end
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
