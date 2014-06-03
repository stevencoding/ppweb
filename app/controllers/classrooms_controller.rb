class ClassroomsController < ApplicationController
  layout 'no_header_footer'
  def show
    @username = current_user ? current_user.username : "guest"
    event_id = params[:event_id]
    if event_id
      event = Event.find(event_id)
      @event_name = event.title
      @event_uid = event.uid
    else
      @event_name = t("classroom.classroom")
    end
  end
  def pproom
    @username = current_user ? current_user.username : "guest"

    # use username for identical roomname
    @roomname = params[:roomname]
    if !User.find_by_username(@roomname)
      redirect_to :root, notice: "#{@roomname}" + t("classroom.room_not_exist")
    end
  end
end