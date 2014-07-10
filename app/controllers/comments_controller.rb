class CommentsController < ApplicationController
	def create
		@comment = current_user.comments.build(params[:comment])
    @comment.save
    redirect_to_target_or_default root_url
	end
end
