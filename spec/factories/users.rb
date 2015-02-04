# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:nickname,100) {|n| "user#{n}" }
    email {"#{nickname}@example.com"}
    #userid Faker::Name.name.split.join
    #email Faker::Internet.email
    password 'password'
    password_confirmation {password}
    user_type_id 2
    avatar "avatar.jpg"
    social_tags ["twitter:username"]
    hometown "mytown"
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