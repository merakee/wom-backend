#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-
# Purpose:: add responses to backend: user model based on content index
#
#
#
# Coptyright:: Indriam Inc.
# Created By:: Bijit Halder
# Created on:: 28 April 2010
# Last Modified:: 20 July 2014
# Modification History::
#
#
#

require './../api_manager.rb'
require './user_manager.rb'

# set server location
am = ApiManager.new(ARGV[0],ARGV[1]!="-s")

# user manager
um = UserManager.new

# start user id
print "Enter starting user id: "
suser = Integer($stdin.gets.chomp) 
puts "stating with user #{suser}................"

(suser..um.total_users).each{|user_id|
# get user
  user = ApiManager::User.new(um.email(user_id),um.password)
  # sign up/sign_in user
  am.sign_up_user(user)
  puts "Posting for user: #{user.email}"
  responses = um.gen_responses_for_user(user_id)
  responses.each{|param|
  # add response
    am.post_response(user,am.create_response(param[0], param[1]))
  }
}