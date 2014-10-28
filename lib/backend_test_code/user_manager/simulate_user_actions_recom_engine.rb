#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-
# Purpose:: Simulate user actions: user model based on content index
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
require './WomClient.rb'
require 'colorize'

class SessionSimulator
  # class variable
  @@api_manager = nil#ApiManager.new
  @@user_manager = UserManager.new
  @@recomd_mamager = WomClient.new
  @@testuser_array =[]
  @@total_users = 3
  @@session_size = 10
  @@total_responses = 0
  @@repeat_content_count = 0
  @@total_likes = 0
  @@total_hates = 0
  
  def initialize(server_flag="-d", verbose= true)
    @@api_manager = ApiManager.new(server_flag,verbose)
  end
  
  class << self
    def api_manager
      @@api_manager || @@api_manager =  ApiManager.new
    end

    def user_manager
      @@user_manager  || @@user_manager = UserManager.new
    end
  end

  class TestUser
    attr_reader :user_id, :params, :api_user, :session_length
    attr_accessor :interaction_count
    def initialize (user_id)
      user_manager = SessionSimulator.user_manager
      @user_id = user_id
      @api_user = ApiManager::User.new(user_manager.email(user_id),user_manager.password)
      @params = user_manager.get_params_for_user(@user_id)
      @session_length = user_manager.rand_pick(30,200)
      @interaction_count = 0
      SessionSimulator.api_manager.sign_up_user(@api_user)
    end

    def description
      {user_id: @user_id, session_length: @session_length, interaction_count: @interaction_count, params: @params, api_user: @api_user.to_json}
    end

  end

  def get_unique_user_id(user_array)
    user_id = @@user_manager.rand_pick(1,1000)
    while user_array.map{|user| user[0]}.include? user_id
      user_id = @@user_manager.rand_pick(1,1000)
    end
    user_id
  end

  def setup_test_users
    @@testuser_array =[]
    (1..@@total_users).each{
      user_id = get_unique_user_id(@@testuser_array)
      test_user = TestUser.new(user_id)
      @@testuser_array  << [user_id,test_user]
    }
  end

  def delete_user(user_array,test_user)
    user_array.delete([test_user.user_id,test_user])
  end

  def add_user(user_array)
    return if user_array.length >= @@total_users
    user_id = get_unique_user_id(user_array)
    test_user = TestUser.new(user_id)
    user_array << [user_id,test_user]
  end

  def check_user_time_out(test_user)
    timed_out = test_user.interaction_count >= test_user.session_length
    delete_user(@@testuser_array,test_user) if timed_out
    add_user(@@testuser_array)
    timed_out
  end

  def get_response(content_id,test_user)
    @@user_manager.get_response_for_user(content_id,test_user.params)
  end

  def get_recommendations(test_user)
    #@@recomd_mamager.recommendContentExternal(test_user.api_user.user_id)
    recom = @@recomd_mamager.recommendContent(test_user.api_user.user_id)
    recom.map{|rec| rec[1]}
  end

  def select_user(user_array)
    user_array[@@user_manager.rand_pick(1,user_array.count)-1][1]
  end

  def post_response(test_user,content_id,response)
    response = @@api_manager.create_response(content_id,response)
    @@api_manager.post_response(test_user.api_user,response)
  end

  def update_stats(test_user,response,rcode)
    test_user.interaction_count += 1
    @@total_responses +=1
    @@repeat_content_count += 1 if rcode==-1
    @@total_likes +=1 if response
    @@total_hates +=1 if !response
  end

  def print_status(scount=@@session_size)
    error_string =  "Repeated Recommendation: #{@@repeat_content_count}\t"
    error_string = error_string.red if @@repeat_content_count>0
    like_string = "% Likes: #{(@@total_likes*100.0/@@total_responses).round(2)}\t".green
    hate_string = "% Hates: #{(@@total_hates*100.0/@@total_responses).round(2)}\t".magenta
    puts "Total respones: #{@@total_responses}\t"+ like_string + hate_string + error_string + "...[#{(scount*100.0/@@session_size).round(2)}%]....."
  end

  def end_session
    @@user_manager.close_db
  end

  def run_session
    # set up and run user session
    setup_test_users
    # run session
    (1..@@session_size).each{|scount|
      test_user = select_user(@@testuser_array)
      #puts test_user.description
      #sleep(1)
      cid_list = get_recommendations(test_user)
      cid_list.each{|cid|
        response = get_response(cid,test_user)
        rcode = post_response(test_user,cid,response)
        update_stats(test_user,response,rcode)
        if rcode==-1
         puts cid_list.inspect 
         puts "user_id: #{test_user.api_user.user_id} content_id: #{cid}" 
      	 exit 
        end
        break if check_user_time_out(test_user)
      }
      print_status(scount)
    }
    end_session
  end
end

SessionSimulator.new(false,false).run_session