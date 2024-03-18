require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  describe "ゲストログイン機能" do
    before do
      visit root_path
      click_link "ゲストログイン"
    end

    it "ゲストユーザーの作成・削除ができること" do
      expect(page).to have_content "ゲストユーザー #{User.last.name} としてログインしました。操作情報はログイン中のみ保持されます。"
      click_link "プロフィール"
      expect(current_path).to eq profile_path(User.last.id)
      click_link "設定"
      expect(page).to have_content "ゲストユーザーの設定情報は編集できません"
    end

    context "ログアウトする場合" do
      it "レコードが1件削除されること" do
        expect { click_link "ログアウト" }.to change { User.count }.by(-1)
        expect(page).to have_content "ゲストユーザー情報が削除されました"
      end
    end

    context "退会する場合" do
      it "レコードが1件削除されること" do
        expect { click_link "退会" }.to change { User.count }.by(-1)
        expect(page).to have_content "ゲストユーザー情報が削除されました"
      end
    end
  end
end
