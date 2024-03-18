require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "page_title" do
    context "引数が空の場合" do
      let(:title) { "" }
      it "「WalkBreak」という文字列が格納される" do
        expect(page_title(title)).to eq "WalkBreak"
      end
    end

    context "引数がnilの場合" do
      let(:title) { nil }
      it "「WalkBreak」という文字列が格納される" do
        expect(page_title(title)).to eq "WalkBreak"
      end
    end

    context "引数に文字列を指定した場合" do
      let(:title) { "散歩ルート作成" }
      it "「引数に指定した文字列 - WalkBreak」という文字列が格納される" do
        expect(page_title(title)).to eq "散歩ルート作成 - WalkBreak"
      end
    end
  end
end
