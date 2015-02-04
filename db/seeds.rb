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
%w[Anonymous Email Facebook Twitter GooglePlus Others].each do |type|
UserType.create :user_type => type
end

# content category

%w[News Secret Rumor LocalInfo Other].each do |type|
ContentCategory.create :category => type
end

# seeds for only Dev 
if Rails.env == 'development'
  
  # # Users
  10.times do
    FactoryGirl.create :user
  end
# 
# 
# # Content: it will create users
  # 50.times do
        # FactoryGirl.create :content, photo_token: nil 
  # end
  
  # user response it will create user and content 
  10.times do 
    loop do
      response =     FactoryGirl.build :user_response
      break response.save if response.valid? 
    end
  end
  
    # comment will create user and content 
  10.times do 
    FactoryGirl.create :comment 
  end

  # comment response will create user and content and comment 
  10.times do 
    loop do
      response =     FactoryGirl.build :comment_response
      break response.save if response.valid? 
    end
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
