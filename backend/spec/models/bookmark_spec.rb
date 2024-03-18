require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let(:user) { create(:user) }
  let(:walking_route) { create(:walking_route, user: user) }

  before do
    sign_in user
  end

  it "一つの散歩ルートに対して同じユーザーが複数回ブックマークしようとすると無効となること" do
    bookmark = build(:bookmark, user_id: user.id, walking_route_id: walking_route.id)
    expect(bookmark).to be_valid
    bookmark.save

    bookmark_same_ids = build(:bookmark, user_id: user.id, walking_route_id: walking_route.id)
    expect(bookmark_same_ids).to be_invalid
  end
end
