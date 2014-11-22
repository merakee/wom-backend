#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-

# Purpose:: WoM Ruby client for testing and accessing the backend. User friendly interace to api_manager.rb
#
# Coptyright:: Indriam Inc.
# Created By:: Bijit Halder
# Created on:: 27 Nov 2014
# Last Modified:: 27 Nov 2014
# Modification History::
#
#

require './api_manager.rb'
require 'benchmark'

class InteractiveClient
  def initialize
    self.action_list
  end

  def set_server
    print "Select server: local (l), development (d - default), or production (p): "
    @server = gets.chomp
    @server = "d" unless @server.eql?("l") || @server.eql?("p")
    @api_manager = ApiManager.new("-"+@server)
    set_and_sign_in_user
  end

  def set_and_sign_in_user
    # get user
    email = "test_user1@test.com"
    password = "testpassword"
    @user = ApiManager::User.new(email,password)

    # sign up/sign_in user
    @api_manager.sign_up_user(@user)
    #puts @user.to_json
  end

  def action_list
    @action_list = []
    @action_list <<  "Get content list (default)"
    @action_list << "Post content"
    @action_list << "Get content (single)"
    @action_list << "Get comments for content"
    @action_list << "Post comment for content"
    @action_list << "Get History - content"
    @action_list << "Get History - comment"
    @action_list << "Get Notification - count"
    @action_list << "Get Notification - list"
    @action_list << "Reset Notification - content"
    @action_list << "Reset Notification - comment"
    @action_list << "Flag content"
  end

  def set_action
    puts "Select action:"
    @action_list.each_with_index{|item, ind| puts "  #{ind+1}. " + item}
    print "Enter your selection: "
    @action = gets.chomp
    @action = @action.to_i if @action.is_a?String
    @action -=1
    @action = 0 if @action > 11 || @action <0
  end

  def take_action
    case @action
    when 1
      post_content
    when 2
      get_conent_single
    when 3
      get_comment_for_content
    when 4
      post_comment_for_content
    when 5
      get_history_content
    when 6
      get_history_comment
    when 7
      get_notifications_count
    when 8
      get_notifications
    when 9
      reset_notifications_content
    when 10
      reset_notifications_comment
    when 11
      flag_content
    else
    get_content_list
    end
  end

  def get_content_list
    puts @action_list[@action] + "...."
    puts @api_manager.get_contentlist(@user)
  end

  def post_content
    print "Enter text: "
    text = gets.chomp
    print "Enter image file name, if any: "
    image = gets.chomp

    content = @api_manager.create_content_with_image(text,image)
    #puts content[:text]
    #puts content[:photo_token][:filename]     if content[:photo_token]
    # puts content[:photo_token][:file]     if content[:photo_token]
    puts @action_list[@action] + ".... with text: " + text + "and image: " + image 
    @api_manager.post_content(content,@user)
  end

  def get_conent_single
    puts @action_list[@action] + "...."
    puts "Not yet implemented"
  end

  def get_comment_for_content
    puts @action_list[@action] + "...."
    puts "Not yet implemented"
  end

  def post_comment_for_content
    puts @action_list[@action] + "...."
    puts "Not yet implemented"
  end

  def get_history_content
    puts @action_list[@action] + "...."
    puts "Not yet implemented"
  end

  def get_history_comment
    puts @action_list[@action] + "...."
    puts "Not yet implemented"
  end

  def get_notifications_count
    puts @action_list[@action] + "...."
    puts "Not yet implemented"
  end

  def get_notifications
    puts @action_list[@action] + "...."
    puts "Not yet implemented"
  end

  def reset_notifications_content
    puts @action_list[@action] + "...."
    puts "Not yet implemented"
  end

  def reset_notifications_comment
    puts @action_list[@action] + "...."
    puts "Not yet implemented"
  end

  def flag_content
    puts @action_list[@action] + "...."
    puts "Not yet implemented"
  end

end

# run interaction client
iClient = InteractiveClient.new
iClient.set_server
while true
  iClient.set_action
  iClient.take_action
  puts
  puts "----------------------------------------"
  puts "Press a key for next action"
  gets.chomp
end
