# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    user
    content
    text {Faker::Lorem.sentence(3)}
  end
end