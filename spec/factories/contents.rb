# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content do
    user
    content_category_id {rand(4)+1}
    text {Faker::Lorem.sentence(3)}

    trait :with_photo do
    #photo_token {Faker::Internet.url}
    #photo_token {filename = "bg#{rand(4)+1}.jpg"; File.join(Rails.root, "/spec/fixtures/content_photos/#{filename}")}
    photo_token {filename = "bg#{rand(4)+1}.jpg"; File.open(File.join(Rails.root, "/spec/fixtures/content_photos/#{filename}"))}
    #photo_token Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/content_photos/bg1.jpg')))
    end
  end
end
