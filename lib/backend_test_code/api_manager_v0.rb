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

require 'rest_client'
require 'json'

# faker set up
#require 'faker'
#require '18n'
#Faker::Config.locale = :en
# set up I18n
#I18n.enforce_available_locales = true
#I18n.default_locale = :en
#I18n::Config::Set = :en
# modify RestClient: add get call with payload
# module RestClient
# def self.get(url, payload, headers={}, &block)
# Request.execute(:method => :get, :url => url, :payload => payload, :headers => headers, &block)
# end
# end
# paths
class ApiManager

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
    else
      @server = "development"
      puts "Api Manager: Connection to AWS Development server with #{@verbose?"verbose":"silent"} mode......"
    end
  end

  def base_url
    #aws_path = 'http://wom-backend-master-env-hv2gxttyvi.elasticbeanstalk.com/'
    path_aws_p = 'http://wom.freelogue.net/'
    path_aws_d = 'http://wom-dev.freelogue.net/'
    path_local = 'http://localhost:3000/'
    api_path = 'api/v0/'
    if @server == "local"
    path_local + api_path
    elsif @server == "production"
    path_aws_p + api_path
    else
    path_aws_d + api_path
    end

  end

  def api_path(path)
    base_url+path
  end

  # rest calls

  def rest_call(verb='post',path='',data={})
    @@response = nil
    @@error = nil
    @@success = false

    begin
      response = RestClient.post path, data.to_json,  :content_type => :json, :accept => :json     if verb=='post'
      #response = RestClient.get  path, data.to_json, :content_type => :json, :accept => :json     if verb=='get'
      #response = RestClient.get  path,  data   if verb=='get'
      response = RestClient.get  path  if verb=='get'
      response = RestClient.delete  path, data.to_json,  :content_type => :json, :accept => :json     if verb=='delete'

      @@response = JSON::parse(response)
      @@success = true
      @@success = @@response['success'] if @@response['success'].nil?
      
    rescue => error
    @@error = error
    @@success = false
    end
  end

  def rest_call_error(msg="Something went wrong: ")
    if !@@success
      reason = @@response['message'] if (defined? @@response['message'])
      reason = @@error.to_s + @@error.response.to_s if reason.nil?
      puts "*** " + msg + reason
      puts '*** Exiting.........................'
      exit
    end
  end

  # API calls

  def api_call(verb='post',path='',data={})
    #puts "verb: #{verb} path:#{path} data:#{data}"
    rest_call(verb,api_path(path),data)
  end

  # User Session: sign_up user
  class User
    attr_reader :email, :password, :password_confirmation, :user_type_id
    attr_accessor :authentication_token, :user_id
    def initialize (email = "admin@system.com", password = "adminpassword")
      @email = email
      @password = password
      @password_confirmation = @password
      @user_type_id = 2
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
    api_call('post','signup',{:user => user.sign_up})
    if @@success
      user.authentication_token = @@response['user']['authentication_token']
      user.user_id = @@response['user']['id']
    end
    if @@error && @@error.http_code==422
      sign_in_user(user)
    else
      rest_call_error("Sign up failed: ")
    end
  end

  def sign_in_user(user = admin_user)
    # User Session: sign_in
    api_call('post','signin',{:user => user.sign_in})
    if @@success
      user.authentication_token = @@response['user']['authentication_token']
      user.user_id = @@response['user']['id']
    end
    rest_call_error("Sign in failed: ")
  end
  
  def create_content_with_image(text=nil, imageFile="",category = 1)
    return create_content(text, category) if imageFile.nil? || imageFile.empty? 
     {:content_category_id => category, :text => text, :photo_token =>   
       {
          file: Base64.encode64(File.new(imageFile, 'rb').read),
          filename:"file.jpg", content_type: "image/jpeg"
         }
       }
  end
  
  def create_content(text=nil, category = 1)
    {:content_category_id => category, :text => text }
  end

  def create_response(content_id, response)
    {:content_id => content_id, :response => response}
  end

  def create_comment(text=nil,content_id=1)
    {:text => text, :content_id => content_id }
  end
  
  def get_content(user = admin_user, content_id)
    # get single content 
    api_call('post','contents/getcontent',{:user => user.auth, :params => {content_id: content_id}})
    if (@@error && @@error.http_code==422)
      puts "*** Get content failed: " +  @@error.to_s + " : " + @@error.response 
    else
      rest_call_error("Get content failed: ")
    end
    if @@success
      @@response['content']
    else
    []
    end
  end

  def get_contentlist(user = admin_user)
    # get  content list
    api_call('post','contents/getlist',{:user => user.auth})
    if (@@error && @@error.http_code==422)
      puts "*** Get content failed: " +  @@error.to_s + " : " + @@error.response 
    else
      rest_call_error("Get content Lst failed: ")
    end
    if @@success
      @@response['contents']
    else
    []
    end
  end

  def flag_content(content_id, user = admin_user)
    # flag content 
    api_call('post','contents/flag',{:user => user.auth, :params => {content_id: content_id}})
    if (@@error && @@error.http_code==422)
      puts "*** Get content failed: " +  @@error.to_s + " : " + @@error.response 
    else
      rest_call_error("Flag content failed: ")
    end
    if @@success
      @@response['flag']
    else
    []
    end
  end
  
  def post_content(content = nil, user = admin_user)
    # post contents
    puts "---------- posting: #{content}" if @verbose
    api_call('post','contents/create', {:user => user.auth, :content => content})
    if (@@error && @@error.http_code==422)
      puts "*** Post content failed: " +  @@error.to_s + " : " + @@error.response 
    else
      rest_call_error("Post content failed: ")
    end
  end

  def post_response(user, response)
    # post response
    puts "---------- posting: #{response} for #{user.email}" if @verbose
    api_call('post','contents/response', {:user => user.auth, :user_response => response})
    if (@@error)
      if (@@error.http_code==422)
        puts "*** Post failed failed: " +  @@error.to_s + " : " + @@error.response 
      return -1
      else
        rest_call_error("Post response failed: ")
      return 0
      end
    else
    return 1
    end
  end
  
  def get_comment(user = admin_user, content_id)
    api_call('post','comments/getlist',{:user => user.auth, :params => {content_id: content_id}})
    if (@@error && @@error.http_code==422)
      puts "*** Get comment failed: " +  @@error.to_s + " : " + @@error.response 
    else
      rest_call_error("Get comment failed: ")
    end
    if @@success
      @@response['comments']
    else
    []
    end
  end
  
  def post_comment(comment = nil, user = admin_user)
    # post comments
    puts "---------- posting: #{comment}" if @verbose
    api_call('post','comments/create', {:user => user.auth, :comment => comment})
    if (@@error && @@error.http_code==422)
      puts "*** Post comment failed: " +  @@error.to_s + " : " + @@error.response 
    else
      rest_call_error("Post comment failed: ")
    end
  end

  def post_comment_response(user, response)
    # post response
    puts "---------- posting: #{response} for #{user.email}" if @verbose
    api_call('post','comments/response', {:user => user.auth, :comment_response => response})
    if (@@error)
      if (@@error.http_code==422)
        puts "*** Post failed failed: " +  @@error.to_s + " : " + @@error.response 
      return -1
      else
        rest_call_error("Post comment response failed: ")
      return 0
      end
    else
    return 1
    end

  end
  
  
  def get_history_content(user = admin_user)
    api_call('post','history/contents',{:user => user.auth, :params => {count: 10}})
    if (@@error && @@error.http_code==422)
      puts "*** Get history content failed: " +  @@error.to_s + " : " + @@error.response 
    else
      rest_call_error("Get history content failed: ")
    end
    if @@success
      @@response['contents']
    else
    []
    end
  end

  def get_history_comment(user = admin_user)
    api_call('post','history/comments',{:user => user.auth, :params => {count: 10}})
    if (@@error && @@error.http_code==422)
      puts "*** Get history comment failed: " +  @@error.to_s + " : " + @@error.response 
    else
      rest_call_error("Get history comment failed: ")
    end
    if @@success
      @@response['comments']
    else
    []
    end
  end

  def get_notifications_count(user = admin_user)
    api_call('post','notifications/count',{:user => user.auth})
    if (@@error && @@error.http_code==422)
      puts "*** Get notifications count failed: " +  @@error.to_s + " : " + @@error.response 
    else
      rest_call_error("Get notifications count failed: ")
    end
    if @@success
      @@response['notifications']
    else
    []
    end
  end
  
  def get_notifications_list(user = admin_user)
    api_call('post','notifications/getlist',{:user => user.auth})
    if (@@error && @@error.http_code==422)
      puts "*** Get notifications list failed: " +  @@error.to_s + " : " + @@error.response 
    else
      rest_call_error("Get notifications list failed: ")
    end
    if @@success
      @@response['notifications']
    else
    []
    end
  end
  
  

end
