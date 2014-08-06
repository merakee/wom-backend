# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_response do
    user 
    content 
    response {x=rand(2);x>0?true:false}
  end
end
