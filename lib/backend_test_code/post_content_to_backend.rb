#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-

# Purpose:: get content for user
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
# all sources of content
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
image  = ARGV[2].strip if ARGV[2]

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

# get contents
Benchmark.bm(7) do |x|
  x.report("for:")   { 
    content = uengine.create_content_with_image(text,image)
    puts content[:text]
    puts content[:photo_token][:filename]     if content[:photo_token]
   # puts content[:photo_token][:file]     if content[:photo_token]
    uengine.post_content(content,user)
  }
end
