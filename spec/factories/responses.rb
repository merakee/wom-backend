# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :response do
    user_id {Faker::Number.number(2)}
    content_id {Faker::Number.number(3)}
    response {rand(2)==0}
  end
end
