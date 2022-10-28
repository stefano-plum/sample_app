class UsersController < ApplicationController
  def new
  end

  def show
    if !!params[:id]
      @user = User.find(params[:id])
    else
      @user = User.find_by(username: params[:username])
    end
  end
end
