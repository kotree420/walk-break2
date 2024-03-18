require 'rails_helper'

RSpec.describe WalkingRoute, type: :model do
  let(:user) { create(:user) }
  let!(:withdrawal_user) { create(:user) }
  let(:walking_route) { create(:walking_route, user: user) }
  let!(:bookmark) { create(:bookmark, user_id: user.id, walking_route_id: walking_route.id) }
  let!(:bookmark_not_eligible) do
    create(:bookmark, user_id: withdrawal_user.id, walking_route_id: walking_route.id)
  end

  before do
    sign_in user
  end

  describe "バリデーションテスト" do
    it "nameがなければ無効であること" do
      walking_route.name = ""
      walking_route.save
      expect(walking_route.errors.full_messages).to include("散歩ルート名: 未入力")
    end

    it "20文字を超えるnameは無効であること" do
      walking_route.name = Faker::Lorem.characters(number: 21)
      walking_route.save
      expect(walking_route.errors.full_messages).to include("散歩ルート名: 20文字以内")
    end

    it "commentがなければ無効であること" do
      walking_route.comment = ""
      walking_route.save
      expect(walking_route.errors.full_messages).to include("コメント: 未入力")
    end

    it "140文字を超えるcommentは無効であること" do
      walking_route.comment = Faker::Lorem.characters(number: 141)
      walking_route.save
      expect(walking_route.errors.full_messages).to include("コメント: 140文字以内")
    end

    it "distanceがなければ無効であること" do
      walking_route.distance = ""
      walking_route.save
      expect(walking_route.errors.full_messages).to include("距離: ルート未出力")
    end

    it "distanceが数値でなければ無効であること" do
      walking_route.distance = Faker::Lorem.characters(number: 5)
      walking_route.save
      expect(walking_route.errors.full_messages).to include("距離: 数値のみ")
    end

    it "durationがなければ無効であること" do
      walking_route.duration = ""
      walking_route.save
      expect(walking_route.errors.full_messages).to include("時間: ルート未出力")
    end

    it "durationが数値でなければ無効であること" do
      walking_route.duration = Faker::Lorem.characters(number: 5)
      walking_route.save
      expect(walking_route.errors.full_messages).to include("時間: 数値のみ")
    end

    it "start_addressがなければ無効であること" do
      walking_route.start_address = ""
      walking_route.save
      expect(walking_route.errors.full_messages).to include("出発地: 未入力")
    end

    it "end_addressがなければ無効であること" do
      walking_route.end_address = ""
      walking_route.save
      expect(walking_route.errors.full_messages).to include("到着地: 未入力")
    end

    it "encorded_pathがなければ無効であること" do
      walking_route.encorded_path = ""
      walking_route.save
      expect(walking_route.errors.full_messages).to include("散歩ルートデータ: ルート未出力")
    end
  end

  describe "ブックマーク機能テスト" do
    it "退会済みのユーザーを除くブックマーク数が返されること" do
      withdrawal_user.update(is_deleted: true)
      expect(walking_route.bookmarks_count(walking_route.bookmarks)).to eq 1
    end
  end
end
