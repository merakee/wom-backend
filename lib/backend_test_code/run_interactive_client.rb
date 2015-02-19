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
require 'rubygems'
require 'highline/import'

class InteractiveClient
  def initialize
    @user =  nil 
    #self.action_list
  end

  def set_server
    print "Select server: local (l), development (d - default), or production (p), or production v2 (p2): "
    #print "Select server: local (l), development (d - default), or production (p): "
    @server = gets.chomp
    @server = "d" unless @server.eql?("l") || @server.eql?("p")  || @server.eql?("p2")
    @api_manager = ApiManager.new("-"+@server)
    set_and_sign_in_user
    set_action_list
  end

  def set_user
    print "Enter User email: "
    email = gets.chomp
    password = ask("Enter password: ") { |q| q.echo = "*" }
    user_type = (email.empty?&&password.empty?)?1:2
    @user = ApiManager::User.new(email,password,user_type)
    set_and_sign_in_user
  end

  def set_and_sign_in_user
    if(!@user)
      # get user
      email = "test_user1@test.com"
      password = "testpassword"
      @user = ApiManager::User.new(email,password)
    end

    # sign up/sign_in user
    @api_manager.sign_up_user(@user)
  #puts @user.to_json
  end

  class ActionItem
    attr_accessor :displayText, :actionKey
    def initialize displayText, actionKey
      @displayText, @actionKey =  displayText, actionKey
    end
  end

  def set_action_list
    @action_list = []
    if @api_manager.api_version==1
      @action_list <<  ActionItem.new("Get content list (default)","content_getlist")
      @action_list <<  ActionItem.new("Post content","content_post")
      @action_list <<  ActionItem.new("Response to a content","content_response")
      @action_list <<  ActionItem.new("***Change User","change_user")
      @action_list <<  ActionItem.new("***Change Server","change_server")
      @action_list <<  ActionItem.new("***Exit","exit")
    elsif @api_manager.api_version==2
      @action_list <<  ActionItem.new("Get content list (default)","content_getlist")
      @action_list <<  ActionItem.new("Get content (single)","content_get")
      @action_list <<  ActionItem.new("Post content","content_post")
      @action_list <<  ActionItem.new("Response to a content","content_response")
      @action_list <<  ActionItem.new("Flag content","content_flag")
      @action_list <<  ActionItem.new("Get comments for content","comment_getlist")
      @action_list <<  ActionItem.new("Post comment for content","comment_post")
      @action_list <<  ActionItem.new("Like a comment","comment_response")
      @action_list <<  ActionItem.new("Get History - content","history_contents")
      @action_list <<  ActionItem.new("Get History - comment","history_comments")
      @action_list <<  ActionItem.new("Get Notification - count","notification_count")
      @action_list <<  ActionItem.new("Get Notification - list","notification_getlist")
      @action_list <<  ActionItem.new("Reset Notification - content","notification_reset_content")
      @action_list <<  ActionItem.new("Reset Notification - comment","notification_reset_comment")
      @action_list <<  ActionItem.new("* Get content Recent list (default)","content_get_recentlist")
      @action_list <<  ActionItem.new("* Delete content","content_delete")
      @action_list <<  ActionItem.new("***Change User","change_user")
      @action_list <<  ActionItem.new("***Change Server","change_server")
      @action_list <<  ActionItem.new("***Exit","exit")
    else #if @api_manager.api_version==3
      @action_list <<  ActionItem.new("Get content list (default)","content_getlist")
      @action_list <<  ActionItem.new("Get content (single)","content_get")
      @action_list <<  ActionItem.new("Post content","content_post")
      @action_list <<  ActionItem.new("Response to a content","content_response")
      @action_list <<  ActionItem.new("Favorite a content","favorite_content")
      @action_list <<  ActionItem.new("Un Favorite a content","unfavorite_content")
      @action_list <<  ActionItem.new("Get favorite content list","favorite_content_getlist")
      @action_list <<  ActionItem.new("Flag content","content_flag")
      @action_list <<  ActionItem.new("Get comments for content","comment_getlist")
      @action_list <<  ActionItem.new("Post comment for content","comment_post")
      @action_list <<  ActionItem.new("Like a comment","comment_response")
      @action_list <<  ActionItem.new("Get History - content","history_contents")
      @action_list <<  ActionItem.new("Get History - comment","history_comments")
      @action_list <<  ActionItem.new("Get Notification - count","notification_count")
      @action_list <<  ActionItem.new("Get Notification - list","notification_getlist")
      @action_list <<  ActionItem.new("Reset Notification - content","notification_reset_content")
      @action_list <<  ActionItem.new("Reset Notification - comment","notification_reset_comment")
      @action_list <<  ActionItem.new("Get user profile","profile_get")
      @action_list <<  ActionItem.new("Update user profile","profile_update")
      @action_list <<  ActionItem.new("* Get content Recent list (default)","content_get_recentlist")
      @action_list <<  ActionItem.new("* Delete content","content_delete")
      @action_list <<  ActionItem.new("***Change User","change_user")
      @action_list <<  ActionItem.new("***Change Server","change_server")
      @action_list <<  ActionItem.new("***Exit","exit")
    end
  end

  def set_action
    puts "Select action:"
    @action_list.each_with_index{|item, ind| puts "  #{ind+1}. " + item.displayText}
    while true
      print "Enter your selection: "
      action_ind = gets.chomp
      action_ind = action_ind.to_i if action_ind.is_a?String
      action_ind -=1
      invalid_action = action_ind > @action_list.count || action_ind <0
      break unless invalid_action
      puts " Not a valid selection. Please select again."
    end
    @action = @action_list[action_ind]
  end

  def take_action
   case @action.actionKey
    when "content_getlist"
      content_getlist
    when "content_get"
      content_get
    when "content_get_recentlist"
      content_get_recentlist
    when "content_post"
      content_post
    when "content_response"
      content_response
    when 'favorite_content'
      favorite_content
    when 'unfavorite_content'
      unfavorite_content
    when 'favorite_content_getlist'
      favorite_content_getlist
    when 'content_flag'
      content_flag
    when 'content_delete'
      content_delete
    when "comment_getlist"
      comment_getlist
    when "comment_post"
      comment_post
    when "comment_response"
      comment_response
    when "history_contents"
      history_contents
    when "history_comments"
      history_comments
    when "notification_count"
      notification_count
    when "notification_getlist"
      notification_getlist
    when "notification_reset_content"
      notification_reset_content
    when "notification_reset_comment"
      notification_reset_comment
    when "profile_get"
      profile_get
    when "profile_update"
      profile_update
    when "change_user"
      set_user
    when "change_server"
      set_server
    when "exit"
      puts "**** Exiting Interactive Client *******\n"
      exit
    else
    content_getlist
   end
  end

  #=============== Get inputs
  def get_content_id
    print "Enter content_id: "
    gets.chomp.to_i
  end

  def get_user_id
    print "Enter user_id: "
    gets.chomp.to_i
  end
  
  def get_comment_id
    print "Enter comment_id: "
    gets.chomp.to_i
  end

  def get_comment_options
    print "Enter mode(1: recent (default), 2: popular): "
    (gets.chomp.to_i==2) ? (mode='popular'):(mode='recent')
    count = get_count
    offset = get_offset
    [mode,count,offset]
  end

  def get_count_offset_options
    #print "Enter mode(1: recent (default), 2: popular): "
    #(gets.chomp.to_i==2) ? (mode='popular'):(mode='recent')
    count = get_count
    offset = get_offset
    [count,offset]
  end

  def get_count
    print "Enter count (default = 10): "
    input = gets.chomp
    return 10 if input.empty?
    input.to_i
  end

  def get_offset
    print "Enter  offset (default = 0): "
    gets.chomp.to_i
  end

  def get_reset_count
    print "Enter  reset count: "
    gets.chomp.to_i
  end

  def get_profile_params
    params = {}
    print "Change Nickname: "
    nickname = gets.chomp
    params[:nickname]=nickname unless nickname.empty?  
    
    print "Change bio: "
    bio = gets.chomp
    params[:bio]=bio unless bio.empty?  
    
    print "Change Hometown: "
    hometown = gets.chomp
    params[:hometown]=hometown unless hometown.empty?  
    
    print "Change email: "
    email = gets.chomp
    params[:email]=email unless email.empty?  
    
    print "Change password: "
    password = gets.chomp
    unless password.empty? 
      print "password confirmation: "
      password_confirmation = gets.chomp
      params[:password_confirmation]=password_confirmation
      params[:password]=password  
    end
    params    
  end

  #=============== Content
  def content_getlist
    puts @action.displayText + "...."
    puts @api_manager.get_contentlist(@user)
  end

  def content_post
    print "Enter text: "
    text = gets.chomp
    print "Enter image file name, if any: "
    image = gets.chomp

    content = @api_manager.create_content_with_image(text,image)
    return if content.nil? 
    #puts content[:text]
    #puts content[:photo_token][:filename]     if content[:photo_token]
    # puts content[:photo_token][:file]     if content[:photo_token]
    puts @action.displayText + ".... with text: " + text + "and image: " + image
    puts @api_manager.post_content(@user,content)
  end

  def content_get_recentlist
    count,offset=get_count_offset_options
    puts @action.displayText + "...."
    puts @api_manager.get_content_recentlist(@user,count,offset)
  end
  
  def content_get
    content_id  = get_content_id
    puts @action.displayText + "...."
    puts @api_manager.get_content(@user,content_id)
  end

  def content_response
    content_id  = get_content_id
    print "Enter response 1. spread (default), 2. kill: "
    (gets.chomp.to_i==2) ? (response=0):(response=1)
    puts @action.displayText + "...."
    puts @api_manager.post_response(@user,content_id,response)
  end
     
  def content_flag
    content_id  = get_content_id
    puts @action.displayText + "...."
    puts @api_manager.flag_content(@user,content_id)
  end

  def content_delete
    content_id  = get_content_id
    admin_pass = ask("Enter admin password: ") { |q| q.echo = "*" }
    puts @action.displayText + "...."
    puts @api_manager.delete_content(@user,content_id,admin_pass)
  end
  
  #=============== Comment
  def comment_getlist
    content_id  = get_content_id
    mode,count,offset=get_comment_options
    puts @action.displayText + "...."
    puts @api_manager.get_comment(@user,content_id,mode,count,offset)
  end

  def comment_post
    content_id  = get_content_id
    print "Enter text: "
    text = gets.chomp
    comment = @api_manager.create_comment(content_id,text)
    puts @action.displayText + "...."
    puts @api_manager.post_comment(@user,comment)
  end

  def comment_response
    comment_id  = get_comment_id
    puts @action.displayText + "...."
    puts @api_manager.post_comment_response(@user,comment_id,true)
  end

  #=============== History

  def history_contents
    count,offset=get_count_offset_options
    puts @action.displayText + "...."
    puts @api_manager.get_history_content(@user,count,offset)
  end

  def history_comments
    count,offset=get_count_offset_options
    puts @action.displayText + "...."
    puts @api_manager.get_history_comment(@user,count,offset)
  end

  #=============== Notification

  def notification_count
    puts @action.displayText + "...."
    puts @api_manager.get_notifications_count(@user)
  end

  def notification_getlist
    puts @action.displayText + "...."
    puts @api_manager.get_notifications_list(@user)
  end

  def notification_reset_content
    content_id =get_content_id
    count = get_reset_count
    puts @action.displayText + "...."
    puts @api_manager.reset_notification_content(@user,content_id,count)
  end

  def notification_reset_comment
    comment_id =get_comment_id
    count = get_reset_count
    puts @action.displayText + "...."
    puts @api_manager.reset_notification_comment(@user,comment_id,count)
  end
  
  #=============== Favorite Content
    
  def favorite_content
    content_id  = get_content_id
    puts @action.displayText + "...."
    puts @api_manager.favorite_content(@user,content_id)
  end
  
  def unfavorite_content
    content_id  = get_content_id
    puts @action.displayText + "...."
    puts @api_manager.unfavorite_content(@user,content_id)
  end
  
  def favorite_content_getlist
    user_id  = get_user_id
    puts @action.displayText + "...."
    puts @api_manager.favorite_content_getlist(@user,user_id)
  end
  
  #=============== User profile
    
  def profile_get
    user_id  = get_user_id
    puts @action.displayText + "...."
    puts @api_manager.profile_get(@user,user_id)
  end

  def profile_update
    params  = get_profile_params
    puts @action.displayText + "...."
    puts @api_manager.profile_update(@user,params)
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
