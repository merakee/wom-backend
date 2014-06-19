# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# users
user1 = User.create :userid => "User1", :email => "user1@example.com", :password => "password"
user2 = User.create :userid => "User2", :email => "user2@example.com", :password => "password"
user3 = User.create :userid => "User3", :email => "user3@example.com", :password => "password"
user4 = User.create :userid => "User4", :email => "user4@example.com", :password => "password"

