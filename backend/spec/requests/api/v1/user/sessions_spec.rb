require 'rails_helper'

RSpec.describe "Api::V1::User::Sessions", type: :request do
  describe "GET /api/v1/user/login" do
    it 'should get new' do
      get api_v1_user_login_path
      expect(response).to have_http_status(200)
    end
  end
end
