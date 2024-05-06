class Api::V1::User::SessionsController < ApplicationController
  def create
    user = Account.find_by(email: params[:login][:email])

    if user&.authenticate(params[:login][:password])
      session[:user_id] = user.id
      response = { message: 'authorized', name: user.name }
    else
      response = { error: 'unauthorized' }
    end

    render json: response
  end
end
