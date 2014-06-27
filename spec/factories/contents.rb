# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content do
    user_id {Faker::Number.number(2)}
    content_category_id {rand(6)+1}
    text {Faker::Lorem.sentence(3)}
    photo_token {Faker::Internet.url}
  end
end
