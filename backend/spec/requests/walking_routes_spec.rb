require 'rails_helper'

RSpec.describe "WalkingRoutes", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:withdrawal_user) { create(:user, :withdrawal) }
  let!(:walking_route) { create(:walking_route, user: user) }
  let!(:walking_route_by_other_user) { create(:walking_route, user: other_user) }
  let!(:walking_route_by_withdrawal_user) { create(:walking_route, user: withdrawal_user) }
  let!(:bookmark) { create(:bookmark, user_id: user.id, walking_route_id: walking_route.id) }

  before do
    sign_in user
  end

  describe "GET /" do
    before do
      get root_path
    end

    it "ステータスコードに 200: OK が返されること" do
      expect(response).to have_http_status(200)
    end
    it "散歩ルートと作成ユーザーが全て表示されていること" do
      expect(response.body).to include(walking_route.name)
      expect(response.body).to include(user.name)
      expect(response.body).to include(walking_route_by_other_user.name)
      expect(response.body).to include(other_user.name)
    end
    it "散歩ルートのブックマーク数が表示されていること" do
      expect(response.body).to include(
        walking_route.bookmarks_count(walking_route.bookmarks).to_s
      )
      expect(response.body).to include(
        walking_route_by_other_user.bookmarks_count(walking_route_by_other_user.bookmarks).to_s
      )
    end
    it "退会済みのユーザーが作成したルートが表示されていないこと" do
      expect(response.body).to_not include(walking_route_by_withdrawal_user.name)
      expect(response.body).to_not include(withdrawal_user.name)
    end
  end

  describe "GET /walking_routes" do
    before do
      get walking_routes_path
    end

    it "ステータスコードに 200: OK が返されること" do
      expect(response).to have_http_status(200)
    end
    it "散歩ルートと作成ユーザーが全て表示されていること" do
      expect(response.body).to include(walking_route.name)
      expect(response.body).to include(user.name)
      expect(response.body).to include(walking_route_by_other_user.name)
      expect(response.body).to include(other_user.name)
    end
    it "散歩ルートのブックマーク数が表示されていること" do
      expect(response.body).to include(
        walking_route.bookmarks_count(walking_route.bookmarks).to_s
      )
      expect(response.body).to include(
        walking_route_by_other_user.bookmarks_count(walking_route_by_other_user.bookmarks).to_s
      )
    end
    it "退会済みのユーザーが作成したルートが表示されていないこと" do
      expect(response.body).to_not include(walking_route_by_withdrawal_user.name)
      expect(response.body).to_not include(withdrawal_user.name)
    end
  end

  describe "GET /walking_routes/search" do
    context "検索ワードありの場合" do
      before do
        walking_route.start_address = "東京都千代田区丸の内"
        walking_route.end_address = "東京都中央区銀座"
        walking_route.save
        walking_route_by_other_user.start_address = "東京都中央区築地"
        walking_route_by_other_user.end_address = "東京都港区六本木"
        walking_route_by_other_user.save
        get search_walking_routes_path, params: { keyword: "千代田区" }
      end

      it "ステータスコードに 200: OK が返されること" do
        expect(response).to have_http_status(200)
      end
      it "検索ワードが表示されていること" do
        expect(response.body).to include("千代田区")
      end
      it "検索結果数が表示されていること" do
        expect(response.body).to include(WalkingRoute.search("千代田区").length.to_s)
      end
      it "検索ワードに対して出発地もしくは到着地の住所が部分一致の散歩ルートのみが表示されていること" do
        expect(response.body).to include(walking_route.name)
        expect(response.body).to_not include(walking_route_by_other_user.name)
      end
      it "退会済みのユーザーが作成したルートが表示されていないこと" do
        expect(response.body).to_not include(walking_route_by_withdrawal_user.name)
        expect(response.body).to_not include(withdrawal_user.name)
      end
    end

    context "検索ワードなしの場合" do
      before do
        get search_walking_routes_path
      end

      it "ステータスコードに 200: OK が返されること" do
        expect(response).to have_http_status(200)
      end
      it "「すべての散歩ルート」と表示されていること" do
        expect(response.body).to include("すべての散歩ルート")
      end
      it "散歩ルートと作成ユーザーが全て表示されていること" do
        expect(response.body).to include(walking_route.name)
        expect(response.body).to include(user.name)
        expect(response.body).to include(walking_route_by_other_user.name)
        expect(response.body).to include(other_user.name)
      end
      it "退会済みのユーザーが作成したルートが表示されていないこと" do
        expect(response.body).to_not include(walking_route_by_withdrawal_user.name)
        expect(response.body).to_not include(withdrawal_user.name)
      end
    end
  end

  describe "GET /walking_routes/:id" do
    before do
      get walking_route_path(walking_route.id)
    end

    it "ステータスコードに 200: OK が返されること" do
      expect(response).to have_http_status(200)
    end
    it "作成者名が表示されていること" do
      expect(response.body).to include(user.name)
    end
    it "作成日時が表示されていること" do
      expect(response.body).to include(walking_route.created_at.strftime("%Y/%m/%d %H:%M:%S"))
    end
    it "散歩ルート名が表示されていること" do
      expect(response.body).to include(walking_route.name)
    end
    it "コメントが表示されていること" do
      expect(response.body).to include(walking_route.comment)
    end
    it "距離が表示されていること" do
      expect(response.body).to include(walking_route.distance.to_s)
    end
    it "時間が表示されていること" do
      expect(response.body).to include(walking_route.duration.to_s)
    end
    it "出発地が表示されていること" do
      expect(response.body).to include(walking_route.start_address)
    end
    it "到着地が表示されていること" do
      expect(response.body).to include(walking_route.end_address)
    end
    it "散歩ルートを表すパスが返されていること" do
      expect(response.body).to include(walking_route.encorded_path)
    end

    context "自ユーザーが作成した散歩ルートの場合" do
      it "編集ボタンが表示されていること" do
        expect(response.body).to include("編集")
      end
    end

    context "別ユーザーが作成した散歩ルートの場合" do
      before do
        sign_in other_user
        get walking_route_path(walking_route.id)
      end

      it "編集ボタンが表示されていないこと" do
        expect(response.body).to_not include("編集する")
      end
    end

    context "退会済みのユーザーが作成した散歩ルートの場合" do
      it "ルートにリダイレクトされること" do
        get walking_route_path(walking_route_by_withdrawal_user.id)
        expect(flash[:info]).to include("退会済みのユーザーです")
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /walking_routes/new" do
    before do
      get new_walking_route_path
    end

    it "ステータスコードに 200: OK が返されること" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /walking_routes" do
    context "全てのカラムが埋められていてリクエストが成功する場合" do
      let(:request) do
        params = attributes_for(:walking_route)
        params[:user_id] = user.id
        post walking_routes_path, params: { walking_route: params }
      end

      it "showアクションにリダイレクトされること" do
        request
        expect(response).to redirect_to(walking_route_path(WalkingRoute.last.id))
      end

      it "送信した散歩ルートが保存されていること" do
        expect { request }.to change(WalkingRoute, :count).by(1)
      end
    end

    context "カラムに不足がありリクエストが失敗する場合" do
      let(:request) do
        post walking_routes_path, params: { walking_route: { name: "散歩ルート1" } }
      end

      before do
        request
      end

      it "newアクションにリダイレクトされること" do
        expect(response).to redirect_to(new_walking_route_path)
      end
      it "リダイレクト先のnewでエラーメッセージが表示されること" do
        get new_walking_route_path
        flash.each do |key, values|
          values.each do |value|
            expect(response.body).to include(value)
          end
        end
      end
      it "リダイレクト後も元々入力されていたパラメータ値は保持されていること" do
        get new_walking_route_path
        session[:new_walking_route].each_value do |value|
          if value.present?
            expect(response.body).to include(value)
          end
        end
      end
    end
  end

  describe "GET /walking_routes/:id/edit" do
    before do
      get edit_walking_route_path(walking_route)
    end

    it "ステータスコードに 200: OK が返されること" do
      expect(response).to have_http_status(200)
    end
    it "作成者名が表示されていること" do
      expect(response.body).to include(user.name)
    end
    it "散歩ルート名が表示されていること" do
      expect(response.body).to include(walking_route.name)
    end
    it "コメントが表示されていること" do
      expect(response.body).to include(walking_route.comment)
    end
    it "距離が表示されていること" do
      expect(response.body).to include(walking_route.distance.to_s)
    end
    it "時間が表示されていること" do
      expect(response.body).to include(walking_route.duration.to_s)
    end
    it "出発地が表示されていること" do
      expect(response.body).to include(walking_route.start_address)
    end
    it "到着地が表示されていること" do
      expect(response.body).to include(walking_route.end_address)
    end
  end

  describe "PATCH /walking_routes/:id" do
    context "リクエストが成功する場合" do
      let(:request) do
        patch walking_route_path(walking_route),
          params: { name: "new_name", comment: "new_comment" }
      end

      before do
        request
      end

      it "flashに完了メッセージが格納され、showにリダイレクトされること" do
        expect(flash[:info]).to include("散歩ルート情報の更新が完了しました")
        expect(response).to redirect_to(walking_route_path(walking_route))
      end

      it "散歩ルート名が更新されていること" do
        expect(walking_route.reload.name).to eq "new_name"
      end

      it "コメントが更新されていること" do
        expect(walking_route.reload.comment).to eq "new_comment"
      end
    end

    context "リクエストが失敗する場合" do
      let(:request) do
        patch walking_route_path(walking_route), params: { name: "", comment: "new_comment" }
      end

      it "flashにエラーメッセージが格納され、editにリダイレクトされること" do
        request
        expect(flash[:warning]).to include("散歩ルート名: 未入力")
        expect(response).to redirect_to(edit_walking_route_path(walking_route))
      end
    end
  end

  describe "DELETE /walking_routes/:id" do
    let(:request) do
      delete walking_route_path(walking_route)
    end

    it "flashに完了メッセージが格納され、ルートにリダイレクトされること" do
      request
      expect(flash[:info]).to include("散歩ルートの削除が完了しました")
      expect(response).to redirect_to root_path
    end

    it "散歩ルートが削除されること" do
      walking_route
      expect { request }.to change(WalkingRoute, :count).by(-1)
    end
  end
end
