# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment_response do
    user 
    comment
    #response {x=rand(2);x>0?true:false}
    response {true}
  end
end
