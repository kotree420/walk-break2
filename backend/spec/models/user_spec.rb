require 'rails_helper'

RSpec.describe User, type: :model do
  # deviseの機能についてはカスタムした部分のみテストを記載
  let(:user) { build(:user) }
  let(:withdrawal_user) { create(:user, :withdrawal) }

  describe "scopeテスト" do
    it "未退会ユーザーのみがUserモデルのレコードに含まれること" do
      withdrawal_user
      expect(User.all).to eq []
      first_user = create(:user)
      expect(User.all).to include(first_user)
    end
  end

  describe "退会機能テスト" do
    it "is_deletedがtrueの場合、無効なユーザーとなること" do
      expect(withdrawal_user.active_for_authentication?).to be_falsey
    end
  end

  describe "バリデーションテスト" do
    it "nameがなければ無効であること" do
      user.name = ""
      user.valid?
      expect(user.errors.full_messages).to include("ユーザー名を入力してください")
    end
    it "20文字を超えるnameは無効であること" do
      user.name = Faker::Name.initials(number: 21)
      user.valid?
      expect(user.errors.full_messages).to include("ユーザー名は20文字以内で入力してください")
    end
    it "nameはユニークでないと無効であること" do
      create(:user, name: "name")
      user.name = "name"
      user.valid?
      expect(user.errors.full_messages).to include("ユーザー名はすでに存在します")
    end
    it "140文字を超えるcommentは無効であること" do
      user.comment = Faker::Lorem.paragraph_by_chars(number: 141)
      user.valid?
      expect(user.errors.full_messages).to include("自己紹介140文字以内")
    end
    it "commentは空白でも有効であること" do
      user.comment = ""
      expect(user).to be_valid
    end
    it "@example.comのドメインは無効であること" do
      user.email = "#{Faker::Lorem.paragraph_by_chars(number: 10)}@example.com"
      user.valid?
      expect(user.errors.full_messages).to include("メールアドレス@example.comのドメインは使用できません")
    end
  end

  describe "ゲストログイン" do
    it "ユーザーレコードが1件作成されること" do
      expect { User.guest }.to change { User.count }.by(1)
    end
    it "emailに@example.comのドメインを持っていること" do
      expect(User.guest.email).to include "@example.com"
    end
  end

  describe "ブックマーク" do
    let(:user) { create(:user) }
    let(:walking_route) { create(:walking_route, user: user) }
    let!(:bookmark) { create(:bookmark, user_id: user.id, walking_route_id: walking_route.id) }

    it "すでに散歩ルートがブックマーク済みの場合、trueを返すこと" do
      expect(user.bookmarked?(walking_route.bookmarks, user.id)).to be_truthy
    end
  end
end
