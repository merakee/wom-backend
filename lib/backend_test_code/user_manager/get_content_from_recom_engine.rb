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
require './../api_manager.rb'
require './user_manager.rb'
require './WomClient.rb'

# set managers
user_manager = UserManager.new
recom_mamager = WomClient.new
api_manager = ApiManager.new(ARGV[0])
# get user
user_id = 436
test_user = ApiManager::User.new(user_manager.email(user_id),user_manager.password)
puts test_user.to_json

# sign up/sign_in user
api_manager.sign_up_user(test_user)
puts test_user.to_json

# get recom
recom = recom_mamager.recommendContent(test_user.user_id)
recom.map{|rec| rec[1]}
