class CommentsController < ApplicationController
	before_filter :not_logged_in
  def create
		@user = current_user
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(params[:comment])
    #debugger
    redirect_to user_post_path(@user.id,@post)
  end

  def destroy
  	@user = current_user
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to user_post_path(@user.id,@post)
  end
end
