require 'rails_helper'

RSpec.describe "Bookmarks", type: :system do
  describe "ブックマーク登録機能" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:walking_route) { create(:walking_route, user: other_user) }

    it "ブックマークアイコンをクリックすると、アイコンがブックマーク済み表示になること" do
      sign_in user
      visit walking_route_path(walking_route.id)

      expect(page).to have_css "#not-yet-bookmarked-icon"
      expect(page).to have_selector ".bookmark-count", text: Bookmark.count

      find(".not-yet-bookmark-btn").click

      expect(page).to have_css "#already-bookmarked-icon"
      expect(page).to have_selector ".bookmark-count", text: Bookmark.count
    end
  end
end
