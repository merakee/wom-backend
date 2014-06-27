# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Dir[Rails.root.join("spec/factories/*.rb")].each {|f| require f}

# parmanent seeds
# user_type
user_type1 = UserType.create :user_type => "Anonymous"
user_type2 = UserType.create :user_type => "Email"
user_type3 = UserType.create :user_type => "Facebook"
user_type4 = UserType.create :user_type => "Twitter"
user_type5 = UserType.create :user_type => "GooglePlus"
user_type6 = UserType.create :user_type => "Others"

# content category
content_category1 = ContentCategory.create :category => "News"
content_category2 = ContentCategory.create :category => "Secret"
content_category3 = ContentCategory.create :category => "Rumor"
content_category4 = ContentCategory.create :category => "Local Info"
content_category5 = ContentCategory.create :category => "Other"

# seeds for only Dev and Test
if Rails.env != 'production'
  
  # Users
  100.times do
    FactoryGirl.create :user
  end


# Content
  1000.times do
    FactoryGirl.create :content
  end
  
  # response
  1000.times do
    FactoryGirl.create :response
  end
  
end

=begin
# old seeds
# users
user1 = User.create :userid => "User1", :email => "user1@example.com", :password => "password", :user_type_id => 1
user2 = User.create :userid => "User2", :email => "user2@example.com", :password => "password", :user_type_id => 1
user3 = User.create :userid => "User3", :email => "user3@example.com", :password => "password", :user_type_id => 1
user4 = User.create :userid => "User4", :email => "user4@example.com", :password => "password", :user_type_id => 2

# content
content1 = Content.create :user_id => 1, :content_category_id => 1, :text => "This is first text from user1"
content2 = Content.create :user_id => 1, :content_category_id => 2, :text => "This is second text from user1"
content3 = Content.create :user_id => 2, :content_category_id => 1, :text => "This is first text from user2"

# Response
response1 = Response.create :user_id => 1, :content_id => 2 , :response => false
response2 = Response.create :user_id => 2, :content_id =>2 , :response => true
response3 = Response.create :user_id => 3, :content_id =>2 , :response => false
response4 = Response.create :user_id => 4, :content_id =>2 , :response => true
response5 = Response.create :user_id => 5, :content_id =>2 , :response => false
response6 = Response.create :user_id => 1, :content_id =>3 , :response => true
response7 = Response.create :user_id => 4, :content_id =>3 , :response => false
response8 = Response.create :user_id => 5, :content_id =>3 , :response => false
response9 = Response.create :user_id => 5, :content_id =>2

=end
