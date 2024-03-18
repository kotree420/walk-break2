FactoryBot.define do
  factory :user do
    name { Faker::Name.initials(number: 20) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    is_deleted { false }
    comment { Faker::Lorem.paragraph_by_chars(number: 140) }

    trait :withdrawal do
      is_deleted { true }
    end
  end
end
