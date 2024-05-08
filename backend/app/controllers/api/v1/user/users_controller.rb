class Api::V1::User::UsersController < ApplicationController
  def show
    user = Account.find(params[:id])

    # TODO: Alba or jsonでレスポンス絞る
    # TODO: APIテスト
    render json: user
  end
end
