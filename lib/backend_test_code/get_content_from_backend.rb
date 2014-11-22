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

# set server location
uengine = ApiManager.new(ARGV[0])
content_id = ARGV[1]

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
    contents = if content_id
    uengine.get_content(user,content_id)
    else
      uengine.get_contentlist(user)
    end
    
    puts contents #.map{|content| content['id']}
  }
end
