require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:withdrawal_user) { create(:user, :withdrawal) }
  let!(:walking_route_created) { create(:walking_route, user: user) }
  let(:walking_route_bookmarked) { create(:walking_route, user: other_user) }
  let!(:bookmark) do
    create(:bookmark, user_id: user.id, walking_route_id: walking_route_bookmarked.id)
  end

  before do
    sign_in user
  end

  describe "GET /profiles" do
    before do
      get profiles_path
    end

    it "ステータスコードに 200: OK が返されること" do
      expect(response).to have_http_status(200)
    end
    it "作成されているユーザー名が全て表示されていること" do
      expect(response.body).to include(user.name)
      expect(response.body).to include(other_user.name)
    end
    it "ユーザーのルート作成数が表示されていること" do
      expect(response.body).to include(user.walking_routes.length.to_s)
    end
    it "ユーザーのブックマーク数が表示されていること" do
      expect(response.body).to include(user.bookmarked_walking_routes.length.to_s)
    end
    it "退会済みのユーザーが表示されていないこと" do
      expect(response.body).to_not include(withdrawal_user.name)
    end
  end

  describe "GET /profiles/search" do
    context "検索ワードありの場合" do
      before do
        user.name = "テストAユーザーさん"
        user.save
        other_user.name = "テストBユーザーさん"
        other_user.save
        get search_profiles_path, params: { keyword: "Aユーザー" }
      end

      it "ステータスコードに 200: OK が返されること" do
        expect(response).to have_http_status(200)
      end
      it "検索ワードが表示されていること" do
        expect(response.body).to include("Aユーザー")
      end
      it "検索結果数が表示されていること" do
        expect(response.body).to include(User.search("Aユーザー").length.to_s)
      end
      it "検索ワードに対してユーザー名が部分一致のユーザーのみが表示されていること" do
        expect(response.body).to include(user.name)
        expect(response.body).to_not include(other_user.name)
      end
      it "退会済みのユーザーが表示されていないこと" do
        expect(response.body).to_not include(withdrawal_user.name)
      end
    end

    context "検索ワードなしの場合" do
      before do
        get search_profiles_path
      end

      it "ステータスコードに 200: OK が返されること" do
        expect(response).to have_http_status(200)
      end
      it "「すべてのユーザー」と表示されていること" do
        expect(response.body).to include("すべてのユーザー")
      end
      it "すべてのユーザーが表示されていること" do
        expect(response.body).to include(user.name)
        expect(response.body).to include(other_user.name)
      end
      it "退会済みのユーザーが表示されていないこと" do
        expect(response.body).to_not include(withdrawal_user.name)
      end
    end
  end

  describe "GET /profiles/:id" do
    context "退会していないユーザーのプロフィールを開く場合" do
      before do
        walking_route_created
        bookmark
        get profile_path(user.id)
      end

      it "ステータスコードに 200: OK が返されること" do
        expect(response).to have_http_status(200)
      end
      it "ユーザー名が表示されていること" do
        expect(response.body).to include(user.name)
      end
      it "自己紹介が表示されていること" do
        expect(response.body).to include(user.comment)
      end
      it "ブックマーク登録した散歩ルート名が表示されていること" do
        expect(response.body).to include(walking_route_bookmarked.name)
      end
      it "作成した散歩ルート名が表示されていること" do
        expect(response.body).to include(walking_route_created.name)
      end
    end

    context "退会済みのユーザーのプロフィールを開く場合" do
      it "ルートにリダイレクトされること" do
        get profile_path(withdrawal_user.id)
        expect(flash[:info]).to include("退会済みのユーザーです")
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /profiles/:id/edit" do
    before do
      get edit_profile_path(user.id)
    end

    it "ステータスコードに 200: OK が返されること" do
      expect(response).to have_http_status(200)
    end
    it "ユーザー名が表示されていること" do
      expect(response.body).to include(user.name)
    end
    it "自己紹介が表示されていること" do
      expect(response.body).to include(user.comment)
    end
  end

  describe "PATCH /profiles/:id" do
    context "リクエストが成功する場合" do
      let(:request) do
        patch profile_path(user.id), params: { name: "new_name", comment: "new_comment" }
      end

      before do
        user.name = "old_name"
        user.comment = "old_comment"
        user.reload
        request
      end

      it "flashに完了メッセージが格納され、showにリダイレクトされること" do
        expect(flash[:info]).to include("プロフィール情報の更新が完了しました")
        expect(response).to redirect_to(profile_path(user.id))
      end
      it "ユーザー名が更新されていること" do
        expect(user.reload.name).to eq "new_name"
      end
      it "自己紹介が更新されていること" do
        expect(user.reload.comment).to eq "new_comment"
      end
    end

    context "リクエストが失敗する場合" do
      let(:request) do
        patch profile_path(user.id), params: { name: "", comment: "new_comment" }
      end

      before do
        request
      end

      it "flashにエラーメッセージが格納され、editにリダイレクトされること" do
        expect(flash[:warning]).to include("ユーザー名を入力してください")
        expect(response).to redirect_to(edit_profile_path(user.id))
      end
    end
  end

  describe "PATCH /profiles/withdrawal" do
    let(:request) do
      patch withdrawal_profiles_path
    end

    before do
      request
    end

    it "サインイン中のユーザーのis_deleteがtrueに更新されること" do
      expect(user.reload.is_deleted).to eq true
    end
    it "サインイン中のユーザーのsession情報が削除されること" do
      expect(session[:user]).to be_falsey
    end
    it "flashに確認メッセージが格納されること" do
      expect(flash[:notice]).to include("退会処理が完了しました")
    end
    it "ルートにリダイレクトされること" do
      expect(response).to redirect_to(root_path)
    end
  end
end
