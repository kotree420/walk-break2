FactoryBot.define do
  factory :walking_route do
    name { Faker::Lorem.characters(number: 20) }
    comment { Faker::Lorem.characters(number: 140) }
    distance { Faker::Number.decimal(l_digits: 2) }
    duration { Faker::Number.number }
    start_address { Faker::Address.full_address }
    end_address { Faker::Address.full_address }
    created_at { Faker::Date }
    encorded_path { "w`xxE{`atYKf@g@IARD@dAVn@AJBJDBFLAPBPJJNFBPDFFPHVPL_@VSfAq@v@a@N?\L`@JnBf@hBb@v@TIp@ABF@ANB?RD@KD?ZMHIC?BME?NeABMTJt@Z`Af@h@VXJj@`@rBtBLBBQBEDFDUGIBUhAb@Zg@r@^H?JSBKFBDGHFCFJHp@`@r@b@LHJY" }
  end
end
