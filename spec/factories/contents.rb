# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content do
    user_id {rand(100)+1}
    content_category_id {rand(4)+1}
    text {Faker::Lorem.sentence(3)}
    photo_token {Faker::Internet.url}
  end
end
