class LikesController < ApplicationController
  def create
    micropost = Micropost.find(params[:micropost_id])
    micropost.like(current_user)
    micropost.save
    redirect_to root_path
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    micropost.unlike(current_user)
    micropost.save
    redirect_to root_path
  end
end
