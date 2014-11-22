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

if ARGV[1] 
  hisotry_mode = ARGV[1] 
else
  hisotry_mode = "con"
end

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
  x.report("for:")   { history = 
    if hisotry_mode == "com"
      uengine.get_history_comment(user)
    else
      uengine.get_history_content(user)
    end
    
    puts history
  }
end
