class CommentsController < ApplicationController
	before_filter :not_logged_in
  def create
		@user = current_user
    @post = @user.posts.find(params[:post_id])
    #debugger
    @comment = @user.posts.comment.create(params[:comment])
    redirect_to user_post_path(@user.id,@post)
  end

  def destroy
  	@user = current_user
    @post = @user.posts.find(params[:post_id])
    @comment = @user.posts.comments.find(params[:id])
    @comment.destroy
    redirect_to user_post_path(@user.id,@post)
  end
end
