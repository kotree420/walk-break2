class WalkingRoutesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :edit_user_session_clear
  before_action :new_walking_route_session_clear, except: [:new]
  before_action :edit_walking_route_session_clear, except: [:edit]

  MAX_HOME_ROUTES_COUNT = 9

  def home
    @walking_routes = WalkingRoute.latest.
      includes(:user, bookmarks: :user).
      limit(MAX_HOME_ROUTES_COUNT)
  end

  def index
    if params[:popular]
      @walking_routes = WalkingRoute.
        includes(:user, :bookmarked_users, bookmarks: :user).
        sort do |a, b|
          b.bookmarked_users.size <=> a.bookmarked_users.size
        end
      @sort_category = "人気順"
    elsif params[:old]
      @walking_routes = WalkingRoute.old.includes(:user, bookmarks: :user)
      @sort_category = "古い順"
    elsif params[:distance_longest]
      @walking_routes = WalkingRoute.distance_longest.includes(:user, bookmarks: :user)
      @sort_category = "距離が長い順"
    elsif params[:distance_shortest]
      @walking_routes = WalkingRoute.distance_shortest.includes(:user, bookmarks: :user)
      @sort_category = "距離が短い順"
    elsif params[:duration_longest]
      @walking_routes = WalkingRoute.duration_longest.includes(:user, bookmarks: :user)
      @sort_category = "時間が長い順"
    elsif params[:duration_shortest]
      @walking_routes = WalkingRoute.duration_shortest.includes(:user, bookmarks: :user)
      @sort_category = "時間が短い順"
    else
      @walking_routes = WalkingRoute.latest.includes(:user, bookmarks: :user)
      @sort_category = "新着順"
    end
  end

  def search
    @keyword = search_params[:keyword]
    @walking_routes = WalkingRoute.search(@keyword).latest.includes(:user, bookmarks: :user)
    @search_results_count = @walking_routes.length
  end

  def show
    @walking_route = WalkingRoute.find(params[:id])
    if @user = @walking_route.user
      @bookmarks = @walking_route.bookmarks.includes([:user])
      @bookmarks_count = @walking_route.bookmarks_count(@bookmarks)
    else
      flash[:info] = ["退会済みのユーザーです"]
      redirect_to root_path
    end
  end

  def new
    @walking_route = WalkingRoute.new(session[:new_walking_route] || {})
    @user = current_user
  end

  def create
    @walking_route = WalkingRoute.new(walking_route_params)
    if @walking_route.save
      flash[:info] = ["ルート作成が完了しました"]
      redirect_to action: :show, id: @walking_route.id
    else
      session[:new_walking_route] = @walking_route
      flash[:warning] = @walking_route.errors.full_messages
      redirect_to action: :new
    end
  end

  def edit
    @user = current_user
    if session[:walking_route_edit].present?
      @walking_route = WalkingRoute.new(session[:walking_route_edit])
    else
      @walking_route = WalkingRoute.find(params[:id])
    end
  end

  def update
    @walking_route = WalkingRoute.find(params[:id])
    if @walking_route.update(walking_route_update_params)
      flash[:info] = ["散歩ルート情報の更新が完了しました"]
      redirect_to action: :show
    else
      session[:walking_route_edit] = @walking_route
      flash[:warning] = @walking_route.errors.full_messages
      redirect_to action: :edit
    end
  end

  def destroy
    @walking_route = WalkingRoute.find(params[:id])
    if @walking_route.destroy
      flash[:info] = ["散歩ルートの削除が完了しました"]
      redirect_to root_path, status: :see_other
    else
      flash[:warning] = @walking_route.errors.full_messages
      redirect_to action: :show, id: @walking_route.id
    end
  end

  private

  def walking_route_params
    params.
      require(:walking_route).
      permit(:name, :comment, :distance, :duration,
        :start_address, :end_address, :encorded_path, :user_id)
  end

  def walking_route_update_params
    params.
      permit(:name, :comment, :distance, :duration,
        :start_address, :end_address, :encorded_path, :user_id)
  end

  def search_params
    params.permit(:keyword)
  end
end
