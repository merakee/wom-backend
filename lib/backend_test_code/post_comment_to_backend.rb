#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-

# Purpose:: get comment for user
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
# all sources of comment
require './api_manager.rb'
require 'benchmark'
require 'base64'

# set variables
if ARGV[1] 
  text = ARGV[1] 
else
  puts "There is no text"
  exit
end
content_id  = ARGV[2]? ARGV[2].strip : 1

# set server location
uengine = ApiManager.new(ARGV[0])

# get user
email = "test_user1@test.com"
password = "testpassword"
user = ApiManager::User.new(email,password)
puts user.to_json

# sign up/sign_in user
uengine.sign_up_user(user)
puts user.to_json

# get comments
Benchmark.bm(7) do |x|
  x.report("for:")   { 
    comment = uengine.create_comment(text,content_id)
    puts comment[:text]
    uengine.post_comment(comment,user)
  }
end
