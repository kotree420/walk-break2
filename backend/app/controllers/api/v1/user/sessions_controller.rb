class Api::V1::User::SessionsController < ApplicationController
  def create
    user = Account.find_by(email: params[:login][:email])

    if user&.authenticate(params[:login][:password])
      session[:user_id] = user.id
      # TODO: idはハッシュ化
      response = { message: 'authorized', id: user.id, name: user.name }
    else
      response = { error: 'login_unauthorized' }
    end

    render json: response
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    @current_user ||= Account.find_by(id: session[:user_id])
    if @current_user
      render json: { logged_in: true, user: current_user }
    else
      render json: { logged_in: false, message: 'ユーザーが存在しません' }
    end
  end
end
