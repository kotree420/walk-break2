require 'rails_helper'

RSpec.describe "Profiles", type: :system do
  let!(:user) { create(:user) }
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

  describe "プロフィール一覧/検索" do
    it "登録済みのユーザーが作成日時順に一覧表示され、ユーザー名で絞り込み検索ができること", js: true do
      visit profiles_path

      user_names = all(".index-profile-name").map(&:text)
      expect(user_names).to eq [other_user.name, user.name]

      within all('.card-body')[1] do
        expect(page).to have_css ".index-edit-dropdown-btn"
      end

      fill_in "ユーザー名で探す", with: other_user.name
      find(".search-form-input").send_keys :return

      search_results_count = User.search(other_user.name).length.to_s
      expect(page).to have_content "#{other_user.name} の検索結果 #{search_results_count}"

      within first('.card-body') do
        expect(page).to have_content other_user.name
        expect(page).to have_content other_user.walking_routes.length.to_s
        expect(page).to have_content other_user.bookmarked_walking_routes.length.to_s
      end
    end
  end

  describe "プロフィール閲覧" do
    context "サインイン中のユーザーのプロフィールを開く場合" do
      it "プロフィール編集機能でユーザー名と自己紹介を編集できること" do
        visit profile_path(user.id)

        expect(page).to have_selector ".show-profile-name", text: user.name
        expect(page).to have_selector ".show-profile-comment", text: user.comment
        expect(page).to have_link "プロフィール編集"
        expect(page).to have_link "設定"

        within first('.created-walking-route-name') do
          expect(page).to have_content walking_route_created.name
        end

        click_link "ブックマーク"

        within first('.bookmarked-walking-route-name') do
          expect(page).to have_content walking_route_bookmarked.name
        end

        # ブックマーク済みの散歩ルートの作成者が退会済みの場合、対象の散歩ルートはブックマーク一覧で非表示になる
        expect(page).to_not have_content walking_route_created_by_withdrawal.name

        click_link "プロフィール編集"

        fill_in "ユーザー名", with: "new_name"
        fill_in "自己紹介", with: "new_comment"
        click_button "更新"

        expect(page).to have_selector ".show-profile-name", text: "new_name"
        expect(page).to have_selector ".show-profile-comment", text: "new_comment"
        expect(page).to have_selector ".show-profile-route-count",
          text: user.walking_routes.length.to_s
        expect(page).to have_selector ".show-profile-bookmark-count",
          text: user.bookmarked_walking_routes.length.to_s
      end
    end

    context "他のユーザーのプロフィールを開く場合" do
      it "プロフィール編集、設定ボタンが表示されていないこと" do
        visit profile_path(other_user.id)

        expect(page).to_not have_link "プロフィール編集"
        expect(page).to_not have_link "設定"
      end
    end
  end
end
