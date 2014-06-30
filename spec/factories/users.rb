# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:userid,100) {|n| "user#{n}" }
    email {"#{userid}@example.com"}
    password 'password'
    password_confirmation {password}
    user_type_id {rand(6)+1}
  # required if the Devise Confirmable module is used
  # confirmed_at Time.now
  end
end