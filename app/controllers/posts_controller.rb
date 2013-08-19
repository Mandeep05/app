class PostsController < ApplicationController
  #before_filter :not_logged_in, :except => :show, :index
  def new
    @user = current_user
    @post = Post.new()
  end

  def create
    @user = current_user
    if @post = @user.posts.create(params[:post])
      redirect_to user_post_path(@user.id,@post.id)
    else
      render 'new'
    end
  end

  def show
    @user = current_user
    @post = Post.find(params[:id])
    @comment = @post.comments.new
    @comments = Post.find(params[:id]).comments
  end

  def index
    @user = current_user
    @post = Post.all
  end

  def edit
    @user = current_user
    @post = Post.find(params[:id])
  end

  def update
    @user= current_user
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to user_posts_path(@user.id)
    else
      render 'edit'
    end
  end

  def destroy
    @user = current_user
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_posts_path(@user.id)
  end
  
end
