class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @walking_route = WalkingRoute.find(params[:walking_route_id])
    @bookmark = @walking_route.bookmarks.new(user_id: current_user.id)
    if @bookmark.save
      redirect_to request.referer
    else
      flash[:warning] = @bookmark.errors.full_messages
      redirect_to request.referer
    end
  end

  def destroy
    @walking_route = WalkingRoute.find(params[:walking_route_id])
    @bookmark = @walking_route.bookmarks.find_by(user_id: current_user.id)
    if @bookmark.present?
      @bookmark.destroy
      redirect_to request.referer, status: :see_other
    else
      redirect_to request.referer
    end
  end
end
