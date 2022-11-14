module SessionsHelper

	# Logs in the given user.
	def log_in(user)
		session[:user_id] = user.id
	end

	# Remembers a user in a persisten session.
    def remember(user)
        user.remember
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

	# Forgets a persistent session.
	def forget(user)
		user.forget
		cookies.delete(:user_id) # Method that removes cookies from the client browser.
		cookies.delete(:remember_token) 
	end

	# Logs out the current user.
	def log_out
		forget(current_user)
		reset_session
		@current_user = nil
	end

	# Looks for the user
	def current_user
		if (user_id = session[:user_id])
			@current_user = @current_user || User.find_by(id: user_id) # if current_user is nil, then executes the User method
		elsif (user_id = cookies.encrypted[:user_id])
			user = User.find_by(id: user_id)
			if user&.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	# Returns true if the user is logged in, false otherwise
	def logged_in?
		!current_user.nil?
	end
end
