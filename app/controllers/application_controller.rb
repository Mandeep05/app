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
		redirect_to log_in_path if !current_user
	end
end
