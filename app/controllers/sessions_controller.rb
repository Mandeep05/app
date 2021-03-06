class SessionsController < ApplicationController
  def new
  end

  def index
    redirect_to root_url
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    #debugger
    if user && User.is_not_active(user.active)
      flash.now.alert ="Please validate your account"
      render "new"
    elsif user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      session[:user_id] = user.id
      @user=current_user
      @post= Post.all
      render "posts/index", :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.delete(:auth_token)
    redirect_to log_in_url, :notice => "Logged out"
  end
end
