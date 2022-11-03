module SessionsHelper

	# Logs in the giver user.
	def log_in(user)
		session[:user_id] = user.id
	end

	# Looks for the user
	def current_user
		@current_user = @current_user || User.find_by(id: session[:user_id]) # if current_user is nil, then executes the User method
	end

end
