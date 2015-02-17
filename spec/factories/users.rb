# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    #sequence(:nickname,100) {|n| "user#{n}" }
    nickname {Faker::Lorem.characters(10)}
    email {"#{nickname}@example.com"}
    #userid Faker::Name.name.split.join
    #email Faker::Internet.email
    password {Faker::Lorem.characters(10)}
    password_confirmation {password}
    user_type_id 2
    avatar {Faker::Avatar.image}
    social_tags ["twitter:"+Faker::Lorem.characters(8)]
    hometown {Faker::Lorem.characters(6)}
    bio {Faker::Lorem.characters(74)}
  # required if the Devise Confirmable module is used
  # confirmed_at Time.now
  end

  trait :anonymous do
    nickname nil
    email nil
    password nil
    password_confirmation nil
    user_type_id 1
  end

end