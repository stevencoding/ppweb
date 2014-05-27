class ClassroomsController < ApplicationController
  layout 'no_header_footer'
  def show
  end
  def pproom
    # use username for identical roomname
    @roomname = params[:roomname]
    if !User.find_by_username(@roomname)
      redirect_to :root, notice: "#{@roomname}" + t("classroom.room_not_exist")
    end
  end
end