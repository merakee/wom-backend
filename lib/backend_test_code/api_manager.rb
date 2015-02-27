#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-

# Purpose:: Api Manager for WoM Backend
# Coptyright:: Indriam Inc.
# Created By:: Bijit Halder
# Created on:: 30 April 2010
# Last Modified:: 30 Nov 2014
# Modification History::
#

require 'rest_client'
require 'json'
require 'base64'


class ApiManager

# class variable

  @@response = nil
  @@error = nil
  @@success = false
  @@admin_user = nil
  def initialize(server_flag="-d", varbose_flag = true)
    @verbose = varbose_flag
    if(server_flag =="-l")
      @server = "local"
      puts "Api Manager: Connection to local server with #{@verbose?"verbose":"silent"} mode......"
    elsif (server_flag =="-p")
      @server = "production"
      puts "Api Manager: Connection to AWS - Production server with #{@verbose?"verbose":"silent"} mode......"
   elsif (server_flag =="-p2")
      @server = "production_v2"
      puts "Api Manager: Connection to AWS - Production server (V2) with #{@verbose?"verbose":"silent"} mode......"
      
    else
      @server = "development"
      puts "Api Manager: Connection to AWS Development server with #{@verbose?"verbose":"silent"} mode......"
    end
  end

# path setup
  def base_url
    #aws_path = 'http://wom-backend-master-env-hv2gxttyvi.elasticbeanstalk.com/'
    path_aws_p = 'http://wom.freelogue.net/'
    path_aws_p2 = 'http://wom-v2.freelogue.net/'
    path_aws_d = 'http://wom-dev.freelogue.net/'
    path_local = 'http://localhost:3000/'
    api_path = 'api/v0/'
    if @server.eql? "local"
    path_local + api_path
    elsif @server.eql? "production"
    path_aws_p + api_path
    elsif @server.eql?"production_v2"
    path_aws_p2 + api_path
    else
    path_aws_d + api_path
    end

  end

  def api_path(path)
    base_url+path
  end

  def api_version
    #return 1 if ["production", "development"].include?@server
    return 3 if ["local", "development"].include?@server
    return 2
  end
  def get_path_for(action)
    # suppoer
    return get_path_for_server_v1(action) if api_version==1

    case action
    when "signup"
      "signup"
    when "signin"
      "signin"
    when "signout"
      "signout"
    when "content_post"
      "contents/create"
    when "content_getlist"
      "contents/getlist"
    when "content_get"
      "contents/getcontent"
    when "content_get_recentlist"
      "contents/getrecent"
    when "content_delete"
      "contents/delete"
    when "content_response"
      "contents/response"
    when "content_flag"
      "contents/flag"
    when "comment_post"
      "comments/create"
    when "comment_getlist"
      "comments/getlist"
    when "comment_response"
      "comments/response"
    when "history_contents"
      "history/contents"
    when "history_comments"
      "history/comments"
    when "notification_getlist"
      "notifications/getlist"
    when "notification_count"
      "notifications/count"
    when "notification_reset_content"
      "notifications/reset/content"
    when "notification_reset_comment"
      "notifications/reset/comment"
    when "favorite_content"
      "favorite_contents/favorite"
    when "unfavorite_content"
      "favorite_contents/unfavorite"
    when "favorite_content_getlist"
      "favorite_contents/getlist"
    when "profile_get"
      "users/profile"
    when "profile_update"
      "users/update"
    else
    puts "***************** ERROR: No such action #{action} on #{@server} server"
    ""
    end
  end

  def get_path_for_server_v1(action)
    case action
    when "signup"
      "sign_up"
    when "signin"
      "sign_in"
    when "signout"
      "sign_out"
    when "content_post"
      "contents"
    when "content_getlist"
      "get_contents"
    when "content_response"
      "user_responses"
    else
    puts "***************** ERROR: No such action #{action} on #{@server} server"
    ""
    end
  end

  # rest calls

  def rest_call(verb='post',path='',data={})
    @@response = nil
    @@error = nil
    @@success = false

    begin
      response = RestClient.post path, data.to_json,  :content_type => :json, :accept => :json     if verb=='post'
      response = RestClient.get  path  if verb=='get'
      response = RestClient.delete  path, data.to_json,  :content_type => :json, :accept => :json     if verb=='delete'

puts response 
      @@response = JSON::parse(response)
      @@success = true
      @@success = @@response['success'] if @@response['success'].nil?

    rescue => error
    @@error = error
    @@success = false
    end
  end

  def rest_call_error(etag="Something went wrong")
    return if @@success
    reason = "*** " +  etag + ": "
    reason += @@response['message']  + ": " if (defined? @@response['message'])
    reason += @@error.to_s + ": " unless @@error.to_s.empty? 
    reason += @@error.response if  @@error.respond_to?("response")
    puts reason
  #unless (@@error && @@error.http_code==422)
  #  puts '*** Exiting.........................'
  #  exit
  #end
  end

  def procesd_response_with_msg(rkey,etag)
    return @@response[rkey]  if @@success
    rest_call_error(etag)
  end
  
  # API calls

  def api_call(verb='post',path='',data={})
    #puts "verb: #{verb} path:#{path} data:#{data}"
    rest_call(verb,api_path(path),data)
  end

  #===========================================
  # User Session
  class User
    attr_reader  :password, :password_confirmation, :user_type_id
    attr_accessor :email, :authentication_token, :user_id
    def initialize (email = "admin@system.com", password = "adminpassword",user_type_id = 2)
      @email = email
      @password = password
      @password_confirmation = @password
      @user_type_id = user_type_id 
      @authentication_token = nil
      @user_id = nil
    end

    def to_json
      {:user_id => @user_id, :user_type_id => @user_type_id, :email => @email, :password => @password, :password_confirmation => @password_confirmation,:authentication_token => @authentication_token}
    end

    def sign_up
      {:user_type_id => @user_type_id, :email => @email, :password => @password, :password_confirmation => @password_confirmation}
    end

    def sign_in
      {:user_type_id => @user_type_id, :email => @email, :password => @password}
    end

    def auth
      {:user_type_id => @user_type_id, :email => @email, :authentication_token => @authentication_token}
    end
  end

  def admin_user
    @@admin_user || @@admin_user=User.new
  end

  def sign_up_user(user = admin_user)
    api_call('post',get_path_for('signup'),{:user => user.sign_up})
    if @@success
      user.email = @@response['user']['email'] if @@response['user']['user_type_id'] == 1
      user.authentication_token = @@response['user']['authentication_token']
      user.user_id = @@response['user']['id']
    end
    if @@error && @@error.respond_to?("http_code") && @@error.http_code==422
      sign_in_user(user)
    else
      rest_call_error("Sign up failed")
    end
  end

  def sign_in_user(user = admin_user)
    # User Session: sign_in
    api_call('post',get_path_for('signin'),{:user => user.sign_in})
    if @@success
      user.authentication_token = @@response['user']['authentication_token']
      user.user_id = @@response['user']['id']
    end
    rest_call_error("Sign in failed")
  end
  
  def sign_out_user(user = admin_user)
    # User Session: sign_out
    api_call('delete',get_path_for('signout'),{:user => user.auth})
    rest_call_error("Sign out failed")
  end
  
  #=========================================
  # Content   
  def create_content_with_image(text=nil, imageFile="",category = 1)
    return create_content(text, category) if imageFile.nil? || imageFile.empty? 
    begin
     {:content_category_id => category, :text => text, :photo_token =>   
       {
         file: Base64.encode64(File.new(imageFile, 'rb').read),
         filename:"file.jpg", content_type: "image/jpeg"
         }
       }
    rescue => e
      puts e.message 
      nil 
    end
  end
  
  def create_content(text=nil, category = 1)
    {:content_category_id => category, :text => text }
  end

  def create_user_response(content_id, response)
    {:content_id => content_id, :response => response}
  end
   
  def create_get_content_recent_params(count=20,offset=0)
    {:count => count, :offset => offset}
  end
  def create_delete_content_params(content_id,admin_pass)
    {content_id: content_id ,admin_pass: admin_pass}
  end
    
  def get_content(user = admin_user, content_id)
    # get single content 
    api_call('post',get_path_for('content_get'),{:user => user.auth, :params => {content_id: content_id}})
    procesd_response_with_msg('content',"Get content failed")
  end

  def get_contentlist(user = admin_user)
    # get  content list
    api_call('post',get_path_for('content_getlist'),{:user => user.auth})
    procesd_response_with_msg('contents',"Get content List failed")
  end

  def get_content_recentlist(user = admin_user,count=20,offset=0)
    rparams = create_get_content_recent_params(count,offset)
    # get  content recent list
    api_call('post',get_path_for('content_get_recentlist'),{:user => user.auth, :params => rparams})
    procesd_response_with_msg('contents',"Get content Recent List failed")
  end
  
  def flag_content(user = admin_user, content_id)
    # flag content 
    api_call('post',get_path_for('content_flag'),{:user => user.auth, :params => {content_id: content_id}})
    procesd_response_with_msg('content_flag',"Flag content failed")
  end
  
  def post_content(user = admin_user, content = nil)
    # post contents
    puts "---------- posting: #{content}" if @verbose
    api_call('post',get_path_for('content_post'), {:user => user.auth, :content => content})
    procesd_response_with_msg('content',"Post content failed")
  end

  def post_response(user = admin_user, content_id, response)
    # post response
    uresponse = create_user_response(content_id, response)
    puts "---------- posting: #{uresponse} for #{user.email}" if @verbose
    api_call('post',get_path_for('content_response'), {:user => user.auth, :user_response => uresponse})
    if(api_version==1)
      procesd_response_with_msg('response',"Post response failed")
    else
      procesd_response_with_msg('content_response',"Post response failed")
    end
  end
  
  def delete_content(user = admin_user,content_id, admin_pass)
    dparams = create_delete_content_params(content_id, admin_pass)
    # delete  content 
    api_call('post',get_path_for('content_delete'),{:user => user.auth, :params => dparams})
    procesd_response_with_msg('content',"Delete content failed")
  end
  
  #=========================================
  # Comment 
  def create_comment(content_id=1,text=nil)
    {:content_id => content_id, :text => text}
  end
  def create_comment_response(comment_id,response)
    {:comment_id => comment_id, :response => response }
  end
    
  def create_comments_params(content_id,mode='recent',count=20,offset=0)
    {:content_id => content_id, :mode => mode, :count => count, :offset => offset}
  end
  
  def get_comment(user = admin_user, content_id=1, mode='recent',count=20, offset=0)
    cparams = create_comments_params(content_id,mode,count,offset)
    api_call('post',get_path_for('comment_getlist'),{:user => user.auth, :params => cparams})
    procesd_response_with_msg('comments',"Get comment failed")
  end
  
  def post_comment(user = admin_user,comment)
    # post comments
    puts "---------- posting: #{comment}" if @verbose
    api_call('post',get_path_for('comment_post'), {:user => user.auth, :comment => comment})
    procesd_response_with_msg('comment',"Post comment failed")
  end

  def post_comment_response(user = admin_user, comment_id, response)
    # post response
    cresponse = create_comment_response(comment_id, response)
    puts "---------- posting: #{cresponse} for #{user.email}" if @verbose
    api_call('post',get_path_for('comment_response'), {:user => user.auth, :comment_response => cresponse})
    procesd_response_with_msg('comment_response',"Post comment response failed")
  end
  
  #=========================================
  # History 
  def create_history_params(count=20,offset=0)
    {:count => count, :offset => offset}
  end
  
  def get_history_content(user = admin_user,count=20,offset=0)
    hparams = create_history_params(count,offset)
    api_call('post',get_path_for('history_contents'),{:user => user.auth, :params => hparams})
    procesd_response_with_msg('contents',"Get history content failed")
  end

  def get_history_comment(user = admin_user, count=20,offset=0)
    hparams = create_history_params(count,offset)
    api_call('post',get_path_for('history_comments'),{:user => user.auth, :params => hparams})
    procesd_response_with_msg('comments',"Get history comment failed")
  end

  #=========================================
  # Notifications
  def create_reset_notification_content_params(content_id, count)
    {:content_id => content_id, :count => count}
  end

  def create_reset_notification_comment_params(comment_id, count)
    {:comment_id => comment_id, :count => count}
  end
    
  def get_notifications_count(user = admin_user)
    api_call('post',get_path_for('notification_count'),{:user => user.auth})
    procesd_response_with_msg('notifications',"Get notifications count failed")
  end
  
  def get_notifications_list(user = admin_user)
    api_call('post',get_path_for('notification_getlist'),{:user => user.auth})
    procesd_response_with_msg('notifications',"Get notifications List failed")
  end

  def reset_notification_content(user = admin_user,content_id,count)
    rnparams = create_reset_notification_content_params(content_id,count)
    api_call('post',get_path_for('notification_reset_content'),{:user => user.auth, :params => rnparams})
    procesd_response_with_msg('content',"Reset notifications Content failed")
  end
  
  def reset_notification_comment(user = admin_user,comment_id,count)
    rnparams = create_reset_notification_comment_params(comment_id,count)
    api_call('post',get_path_for('notification_reset_comment'),{:user => user.auth, :params => rnparams})
    procesd_response_with_msg('comment',"Reset notifications Comment failed")
  end  
   
  #=========================================
  # Favorite Content   
  def favorite_content(user = admin_user, content_id)
    # favorite content 
    api_call('post',get_path_for('favorite_content'),{:user => user.auth, :params => {content_id: content_id}})
    procesd_response_with_msg('favorite_content',"Favorite content failed")
  end

  def unfavorite_content(user = admin_user, content_id)
    # unfavorite content 
    api_call('post',get_path_for('unfavorite_content'),{:user => user.auth, :params => {content_id: content_id}})
    procesd_response_with_msg('message',"Unfavorite content failed")
  end
  
  def favorite_content_getlist(user = admin_user, user_id)
    # get favorite content list 
    api_call('post',get_path_for('favorite_content_getlist'),{:user => user.auth, :params => {user_id: user_id}})
    procesd_response_with_msg('contents',"Get favorite content list failed")
  end
  
  #=========================================
  # User profile 
  def  process_profile_params(params)
    # need to add logic to filter out nil params
    params 
  end
  def profile_get(user = admin_user,user_id)
    api_call('post',get_path_for('profile_get'),{:user => user.auth, :params => {user_id: user_id}})
    procesd_response_with_msg('user',"Get user profile failed")
  end

  def profile_update(user = admin_user, params)
    params = process_profile_params(params)
    if params.empty? 
      puts "Nothing to update" 
      return 
    end
    
    api_call('post',get_path_for('profile_update'),{:user => user.auth, :params => params})
    user.email = @@response['user']['email'] if @@success 
    procesd_response_with_msg('user',"Update Profile failed")
  end
end
