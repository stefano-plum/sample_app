class SessionsController < ApplicationController
  def new
  end

  def create
    login_username = params[:session][:username].downcase
    login_password = params[:session][:password]
    user = User.where("username = :query OR email = :query", query: login_username).first
    if user && user.authenticate(login_password)
      reset_session
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email or username and password combination' # Can be better
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
  end
end
