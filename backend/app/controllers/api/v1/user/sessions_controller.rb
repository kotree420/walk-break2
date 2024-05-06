class Api::V1::User::SessionsController < ApplicationController
  def create
    payload = login_params;

    render json: payload
  end

  private
    def login_params
      params.require(:login).permit(:email, :password)
    end
end
