class CommentsController < ApplicationController
	def create
		@comment = current_user.comments.build(params[:comment])
    @comment.save
	end
end
