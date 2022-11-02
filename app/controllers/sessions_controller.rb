class SessionsController < ApplicationController
  def new
  end

  def create
    login_username = params[:session][:username]
    login_password = params[:session][:password]
    user = User.where("username = :query OR email = :query", query: login_username.downcase).first
    if user && user.authenticate(login_password)
      # Log the user in and redirect to the user's show page.
    else
      flash[:danger] = 'Invalid username/email or password combination' # Can be better
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
  end

  # private
  #   def authenticate_email(email)
  #     user = User.find_by(email: email.downcase).or(username: email)
  #   end

  #   def authenticate_username(username)
  #     user = User.find_by(username: username.downcase)
  #   end
end
