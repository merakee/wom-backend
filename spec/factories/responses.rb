# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_response do
    user_id {Faker::Number.number(2)}
    content_id {Faker::Number.number(3)}
    response {x=rand(5);x>1?true:false}
  end
end
