class UsersController < ApplicationController
  
  def show
    if !!params[:id]
      @user = User.find(params[:id])
    else
      @user = User.find_by(username: params[:username])
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome #{@user.name.capitalize()} to the Sample App"
      redirect_to @user
    else 
      render :new, status: :unprocessable_entity
    end
  end

  private  
    def user_params
      params.require(:user).permit(:username, :name, :email, :password, :password_confirmation)
    end
end
