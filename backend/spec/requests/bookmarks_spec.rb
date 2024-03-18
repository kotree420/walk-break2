require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let(:user) { create(:user) }
  let(:walking_route) { create(:walking_route, user: user) }
  let(:bookmark) { create(:bookmark, user_id: user.id, walking_route_id: walking_route.id) }
  let!(:headers) { { HTTP_REFERER: "http://www.example.com/walking_routes/1" } }

  before do
    sign_in user
  end

  describe "POST /walking_routes/:walking_route_id/bookmarks" do
    let(:request) do
      post walking_route_bookmarks_path(walking_route.id),
        params: { bookmark: { user_id: user.id, walking_route_id: walking_route.id } },
        headers: headers
    end

    it "エラーメッセージなしで元ページにリダイレクトされること" do
      request
      expect(flash[:warning]).to be_falsey
      expect(response).to redirect_to headers[:HTTP_REFERER]
    end

    it "ブックマークが保存されること" do
      expect { request }.to change(Bookmark, :count).by(1)
    end
  end

  describe "DELETE /walking_routes/:walking_route_id/bookmarks" do
    let(:request) do
      delete walking_route_bookmarks_path(walking_route.id), headers: headers
    end

    it "元ページにリダイレクトされること" do
      request
      expect(response).to redirect_to headers[:HTTP_REFERER]
    end

    it "ブックマークが削除されること" do
      bookmark
      expect { request }.to change(Bookmark, :count).by(-1)
    end
  end
end
