# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
 factory :user do
   userid "user1"
   email "user1@example.com"
   password "password"
 end
 
end


=begin
   factory :user do
    sequence(:userid, 100) {|n| "user#{n}" }
    email {"#{userid}@example.com"}
    password 'password'
    password_confirmation {password}
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
=end 