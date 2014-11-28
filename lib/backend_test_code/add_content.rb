#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-

# Purpose:: collect feed from various sources and add to the wom back end content
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
require './BuzzFeed/BuzzFeed_RSS.rb'
require './api_manager.rb'

# set server location 
uengine = ApiManager.new(ARGV[0])

# sign up/sign_in user
user=ApiManager::User.new
uengine.sign_up_user(user)

# get feed from buzzfeed
feed = get_buzzfeed()

# post feed
feed.each { |text|
  uengine.post_content(user,uengine.create_content(text))
}
