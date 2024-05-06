require 'rails_helper'

RSpec.describe "Api::V1::User::Sessions", type: :request do
  describe "POST /api/v1/user/login" do
    let(:account) do
      Account.new(
        name: 'example account',
        email: 'account@example.com',
        password: 'foobar',
        password_confirmation: 'foobar'
      )
    end

    before do
      account.save
      post api_v1_user_login_path, params: {
        email: "account@example.com",
        password: "foobar",
      }
    end

    it 'should return 200' do
      expect(response).to have_http_status(200)
    end

    it 'should return authorized' do
      expect(response.body).to include('authorized', account.name)
    end

    it 'should return unauthorized' do
      post api_v1_user_login_path, params: {
        email: "account@example.com",
        password: "foovar",
      }
      expect(response.body).to include('unauthorized')
    end
  end
end
