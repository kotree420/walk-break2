require 'rails_helper'

RSpec.describe "WalkingRoutes", type: :system do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:withdrawal_user) { create(:user, :withdrawal) }
  let!(:walking_route_created) { create(:walking_route, user: user) }
  let!(:walking_route_bookmarked) { create(:walking_route, user: other_user) }
  let!(:walking_route_created_by_withdrawal) { create(:walking_route, user: withdrawal_user) }
  let!(:bookmark) do
    create(:bookmark, user_id: user.id, walking_route_id: walking_route_bookmarked.id)
  end
  let!(:bookmark_created_by_withdrawal) do
    create(:bookmark, user_id: user.id, walking_route_id: walking_route_created_by_withdrawal.id)
  end

  before do
    sign_in user
  end

  describe "散歩ルート一覧/検索" do
    before do
      walking_route_created.distance = 0.8
      walking_route_created.duration = 10
      walking_route_created.save

      walking_route_bookmarked.distance = 1.5
      walking_route_bookmarked.duration = 20
      walking_route_bookmarked.save
    end

    it "ホーム画面にて作成済みの散歩ルートが作成日時順に一覧表示され、住所で絞り込み検索ができること", js: true do
      visit root_path

      walking_route_names = all(".index-walking-route-name").map(&:text)
      expect(walking_route_names).to eq [walking_route_bookmarked.name, walking_route_created.name]

      # walking_route_bookmarked
      within all('.card-body')[0] do
        expect(page).to have_css "#already-bookmarked-icon"
      end

      # walking_route_created
      within all('.card-body')[1] do
        expect(page).to have_css ".index-edit-dropdown-btn"
        expect(page).to have_css "#not-yet-bookmarked-icon"
      end

      fill_in "住所、地名で探す", with: walking_route_bookmarked.start_address
      find(".search-form-input").send_keys :return

      search_results_count = WalkingRoute.search(walking_route_bookmarked.start_address).length.to_s
      expect(page).
        to have_content "#{walking_route_bookmarked.start_address} の検索結果 #{search_results_count}"

      within first('.card-body') do
        expect(page).to have_content walking_route_bookmarked.name
        expect(page).to have_content walking_route_bookmarked.start_address
        expect(page).to have_content walking_route_bookmarked.distance
        expect(page).to have_content walking_route_bookmarked.duration
      end
    end

    it "一覧表示画面にて散歩ルートのソートができること" do
      visit walking_routes_path

      click_link "新着順"
      walking_route_names = all(".index-walking-route-name").map(&:text)
      expect(walking_route_names).to eq [walking_route_bookmarked.name, walking_route_created.name]

      click_link "古い順"
      walking_route_names = all(".index-walking-route-name").map(&:text)
      expect(walking_route_names).to eq [walking_route_created.name, walking_route_bookmarked.name]

      click_link "人気順"
      walking_route_names = all(".index-walking-route-name").map(&:text)
      expect(walking_route_names).to eq [walking_route_bookmarked.name, walking_route_created.name]

      click_link "距離が長い順"
      walking_route_names = all(".index-walking-route-name").map(&:text)
      expect(walking_route_names).to eq [walking_route_bookmarked.name, walking_route_created.name]

      click_link "距離が短い順"
      walking_route_names = all(".index-walking-route-name").map(&:text)
      expect(walking_route_names).to eq [walking_route_created.name, walking_route_bookmarked.name]

      click_link "時間が長い順"
      walking_route_names = all(".index-walking-route-name").map(&:text)
      expect(walking_route_names).to eq [walking_route_bookmarked.name, walking_route_created.name]

      click_link "時間が短い順"
      walking_route_names = all(".index-walking-route-name").map(&:text)
      expect(walking_route_names).to eq [walking_route_created.name, walking_route_bookmarked.name]
    end
  end

  describe "散歩ルート作成機能", js: true do
    it "散歩ルート作成画面にてルート作成を実行すると、詳細表示ページに遷移して作成した情報が表示されること", js: true do
      visit new_walking_route_path

      # マップが表示されているか
      expect(page).to have_css ".gm-style"

      fill_in "散歩ルート名:", with: "散歩ルート1"
      fill_in "ひとことコメント:", with: "散歩コメント1"
      fill_in "出発地:", with: "日本、〒100-0005 東京都千代田区丸の内１丁目９ JR 東京駅"
      click_button "経由地を追加"
      click_button "経由地を追加"
      fill_in "waypoint1", with: "日本、〒100-0006 東京都千代田区有楽町２丁目９ 有楽町駅"
      fill_in "waypoint2", with: "日本、〒100-0006 東京都千代田区有楽町１丁目 日比谷駅"
      fill_in "到着地:", with: "日本、〒104-0061 東京都中央区銀座４丁目１−２ 銀座駅"
      click_button "ルート出力"

      # マップ上に地点マーカーが表示されているか
      expect(page).to have_css "#gmimap0"
      expect(page).to have_css "#gmimap1"
      expect(page).to have_css "#gmimap2"
      expect(page).to have_css "#gmimap3"

      # マップ上にルートポリラインが表示されているか
      within ".gm-style" do
        expect(
          find("img[src='https://maps.gstatic.com/mapfiles/undo_poly.png']", visible: false)
        ).to be_truthy
      end

      # 経由地を削除するとマーカーが一つ消え、id名が振り直される
      click_button "経由地を削除"
      expect(page).to_not have_css "#gmimap0"
      expect(page).to_not have_css "#gmimap1"
      expect(page).to_not have_css "#gmimap2"
      expect(page).to_not have_css "#gmimap3"
      expect(page).to have_css "#gmimap4"
      expect(page).to have_css "#gmimap5"
      expect(page).to have_css "#gmimap6"

      expect(page).to have_field "距離/km", with: "1.113"
      expect(page).to have_field "時間/分", with: "14"
      expect(page).to have_field "出発地:", with: "日本、〒100-0005 東京都千代田区丸の内１丁目９ JR 東京駅"
      expect(page).to have_field "waypoint1", with: "日本、〒100-0006 東京都千代田区有楽町２丁目９ 有楽町駅"
      expect(page).to have_field "到着地:", with: "日本、〒104-0061 東京都中央区銀座４丁目１−２ 銀座駅"
      click_button "ルート作成"

      expect(current_path).to eq walking_route_path(WalkingRoute.last.id)
      expect(page).to have_content "ルート作成が完了しました"

      within ".gm-style" do
        expect(
          find("img[src='https://maps.gstatic.com/mapfiles/undo_poly.png']", visible: false)
        ).to be_truthy
      end

      expect(page).to have_selector "#created-at-value",
        text: "作成日時 #{WalkingRoute.last.created_at.strftime("%Y/%m/%d %H:%M:%S")}"
      expect(page).to have_selector "#show-walking-route-name", text: WalkingRoute.last.name
      expect(page).to have_selector "#show-walking-route-comment", text: WalkingRoute.last.comment
      expect(page).to have_selector "#show-total-distance", text: "#{WalkingRoute.last.distance}km"
      expect(page).to have_selector "#show-total-duration", text: "#{WalkingRoute.last.duration}分"
      expect(page).to have_selector "#show-start-address", text: WalkingRoute.last.start_address
      expect(page).to have_selector "#show-end-address", text: WalkingRoute.last.end_address
    end

    it "経由地は10を越える数を追加できないこと", js: true do
      visit new_walking_route_path

      11.times do
        click_button "経由地を追加"
      end

      expect(all(".waypoint").count).to eq 10
    end
  end

  describe "散歩ルート編集機能", js: true do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:walking_route) do
      create(
        :walking_route,
        start_address: "日本、〒100-0005 東京都千代田区丸の内１丁目９ JR 東京駅",
        end_address: "日本、〒104-0061 東京都中央区銀座４丁目１−２ 銀座駅",
        encorded_path:
          "o}wxEqoatYAFjGfBDSH[LFNFR@LE`Ah@PITLVJb@TbDfBZRVTANl@NFBJ@LB`@VZRBKZNrAr@l@b@hBhA\LAFA@PD
          d@Zv@f@`BbAtA|@^TSh@",
        user: user
      )
    end

    context "サインイン中のユーザーで作成した散歩ルートを開く場合" do
      it "散歩ルート情報を編集できること" do
        sign_in user
        visit walking_route_path(walking_route)

        find('.edit-dropdown-btn').click
        click_link '編集'

        expect(current_path).to eq edit_walking_route_path(WalkingRoute.last.id)
        expect(page).to have_css ".gm-style"

        fill_in "散歩ルート名:（20文字以内）", with: "散歩ルート1"
        fill_in "ひとことコメント:（140文字以内）", with: "散歩コメント1"
        fill_in "出発地:", with: "日本、〒100-0005 東京都千代田区丸の内１丁目９ JR 東京駅"
        fill_in "到着地:", with: "日本、〒104-0061 東京都中央区銀座４丁目１−２ 銀座駅"
        click_button "ルート出力"

        expect(page).to have_css "#gmimap0"
        expect(page).to have_css "#gmimap1"
        within ".gm-style" do
          expect(
            find("img[src='https://maps.gstatic.com/mapfiles/undo_poly.png']", visible: false)
          ).to be_truthy
        end

        expect(page).to have_field "距離/km", with: "1.021"
        expect(page).to have_field "時間/分", with: "13"
        expect(page).to have_field "出発地:", with: "日本、〒100-0005 東京都千代田区丸の内１丁目９ JR 東京駅"
        expect(page).to have_field "到着地:", with: "日本、〒104-0061 東京都中央区銀座４丁目１−２ 銀座駅"
        click_button "更新"

        expect(current_path).to eq walking_route_path(WalkingRoute.last.id)
        expect(page).to have_content "散歩ルート情報の更新が完了しました"

        within ".gm-style" do
          expect(
            find("img[src='https://maps.gstatic.com/mapfiles/undo_poly.png']", visible: false)
          ).to be_truthy
        end

        expect(page).to have_selector "#created-at-value",
          text: "作成日時 #{WalkingRoute.last.created_at.strftime("%Y/%m/%d %H:%M:%S")}"
        expect(page).to have_selector "#show-walking-route-name",
          text: WalkingRoute.last.name
        expect(page).to have_selector "#show-walking-route-comment",
          text: WalkingRoute.last.comment
        expect(page).to have_selector "#show-total-distance",
          text: "#{WalkingRoute.last.distance}km"
        expect(page).to have_selector "#show-total-duration",
          text: "#{WalkingRoute.last.duration}分"
        expect(page).to have_selector "#show-start-address",
          text: WalkingRoute.last.start_address
        expect(page).to have_selector "#show-end-address",
          text: WalkingRoute.last.end_address
      end
    end

    context "サインインしていないユーザーのプロフィールを開く場合" do
      it "編集ボタンが表示されていないこと" do
        sign_in other_user
        visit walking_route_path(walking_route)

        expect(page).to_not have_css ".edit-dropdown-btn"
      end
    end
  end

  describe "散歩ルート削除機能", js: true do
    let(:user) { create(:user) }
    let(:walking_route) do
      create(
        :walking_route,
        start_address: "日本、〒100-0005 東京都千代田区丸の内１丁目９ JR 東京駅",
        end_address: "日本、〒104-0061 東京都中央区銀座４丁目１−２ 銀座駅",
        user: user
      )
    end

    it "サインイン中のユーザーで作成した散歩ルートを削除できること" do
      sign_in user
      visit walking_route_path(walking_route)

      find('.edit-dropdown-btn').click
      click_button '削除'

      expect do
        expect(page.accept_confirm).to eq "このルートを削除しますか？"
        expect(page).to have_content "散歩ルートの削除が完了しました"
        expect(current_path).to eq root_path
      end.to change(WalkingRoute, :count).by(-1)
    end
  end
end
