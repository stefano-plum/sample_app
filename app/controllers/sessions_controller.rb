class SessionsController < ApplicationController

  def new
  end

  def create
    login_username = params[:session][:username].downcase
    login_password = params[:session][:password]
    user = User.where("username = :query OR email = :query", query: login_username).first
    if user&.authenticate(login_password)
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email or username and password combination' # Can be better
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :username, :password, :password_confirmation)
    end
end
