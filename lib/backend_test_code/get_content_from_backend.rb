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
require './BuzzFeed/BuzzFeed_RSS.rb'
require './api_manager.rb'

# set server location 
uengine = ApiManager.new(ARGV[0]=="-l")

# sign up/sign_in user
uengine.sign_up_user 

# get contents
contents = uengine.get_content

puts contents