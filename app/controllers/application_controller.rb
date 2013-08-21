class ApplicationController < ActionController::Base
	protect_from_forgery
	helper_method :current_user

	private

	def current_user
	  @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
	end

	def not_logged_out
		redirect_to user_path(current_user) if current_user
	end

	def not_logged_in
		redirect_to log_in_path, :notice => "You need to log in first" if !current_user
	end

	def not_allowed
  	if current_user.id != Post.find(params[:id]).user_id
  		redirect_to root_url, :notice => "You are not authorized to do this"
  	end
  end
end
