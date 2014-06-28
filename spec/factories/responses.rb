# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :response do
    user_id {Faker::Number.number(2)}
    content_id {Faker::Number.number(3)}
    response {x=rand(3); (x==0)?nil:(x==1?true:false)}
  end
end
