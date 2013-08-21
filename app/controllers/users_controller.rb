class UsersController < ApplicationController
	before_filter :not_logged_out, :except => :show

  def new
  	@user = User.new
  end

	def create
		@user = User.new(params[:user])
		if @user.save
			# User.send_activation
			UserMailer.activation(@user).deliver
		  redirect_to log_in_url, :notice => "Signed up! Email has been send to your id"
		else
		  render "new"
		end
	end

	def show
		 
	end

	def activate
	  @user = User.find_by_signup_token(params[:token])
	  @user.update_attribute(:active, true)
	  redirect_to log_in_path, notice: "Your account is now activated."
  end
end
