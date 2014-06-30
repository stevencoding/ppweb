class MessagesController < ApplicationController
  def create
    @message = Message.create(params[:message])
    @message.save

    redirect_to_target_or_default :root, notice: "successfully sent message"
  end
end
