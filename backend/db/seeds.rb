# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

account_array = []
user_array = []

2.times do |n|
  account_array << Account.create!(
    name: "テストユーザー#{n + 1}",
    email: "test#{n + 1}@test.com",
    password: "testuser#{n + 1}",
  )
end

2.times do |n|
  user_array << User.create!(
    name: "テストユーザー#{n + 1}",
    email: "test#{n + 1}@test.com",
    password: "testuser#{n + 1}",
    comment: "テストユーザー#{n + 1}です。"
  )
end

user_array[0].walking_routes.create!(
      user_id: user_array[0].id,
      name: "テストルート1",
      comment: "テストルート1です。",
      distance: 1.021,
      duration: 13,
      start_address: "日本、〒100-0005 東京都千代田区丸の内１丁目９ JR 東京駅",
      end_address: "日本、〒104-0061 東京都中央区銀座４丁目１−２ 銀座駅",
      encorded_path: "o}wxEqoatYAFjGfBDSH[LFNFR@LE`Ah@PITLVJb@TbDfBZRVTANl@NFBJ@LB`@VZRBKZNrAr@l@b@hBhA\\LAFA@PDd@Zv@f@`BbAtA|@^TSh@"
)

user_array[1].walking_routes.create!(
      user_id: user_array[1].id,
      name: "テストルート2",
      comment: "テストルート2です。",
      distance: 1.161,
      duration: 15,
      start_address: "日本、〒150-0002 東京都渋谷区渋谷２丁目２４ 渋谷駅",
      end_address: "日本、〒150-0034 東京都渋谷区代官山町１９−４ 代官山駅",
      encorded_path: "a`sxE_~tsYl@g@l@a@lDeBjBaAzBmBbA{@|@u@r@i@JAFCt@m@Tb@VS^[DDw@n@JXJp@FPVp@Tl@LTL@`@b@TNRFVN~@l@FPFh@`@\\`Az@TAPAHGLBR?XBp@Hb@J\\NPR\\h@Vl@Xv@DBL@AC"
)

1.times do |n|
  Bookmark.create!(
    user_id: user_array[n].id,
    walking_route_id: user_array[n+1].walking_routes.first.id
  )
end
