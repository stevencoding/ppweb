class MessagesController < ApplicationController
  def create
    @message = Message.create(params[:message])
    @message.save
    Notification.notify("message", @message.sender, @message.receiver, @message)

    redirect_to_target_or_default :root, notice: t("message.suc_sent")
  end
end
