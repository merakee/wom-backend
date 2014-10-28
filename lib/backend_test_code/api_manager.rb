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
    path_aws_d = 'http://wom_dev.freelogue.net/'
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
      reason = @@error.to_s if reason.nil?
      puts "*** " + msg + reason
      puts '*** Exiting.........................'
      exit
    end
  end

  # API calls

  def api_call(verb='post',path='',data={})
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
    api_call('post','sign_up',{:user => user.sign_up})
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
    api_call('post','sign_in',{:user => user.sign_in})
    if @@success
      user.authentication_token = @@response['user']['authentication_token']
      user.user_id = @@response['user']['id']
    end
    rest_call_error("Sign in failed: ")
  end

  def create_content(text=nil, category = 1)
    {:content_category_id => category, :text => text}
  end

  def create_response(content_id, response)
    {:content_id => content_id, :response => response}
  end

  def get_content(user = admin_user)
    api_call('post','get_contents',{:user => user.auth})
    if (@@error && @@error.http_code==422)
      puts "*** Get content failed: 422 Unprocessable Entity"
    else
      rest_call_error("Get content failed: ")
    end
    if @@success
      @@response['contents']
    else
    []
    end
  end

  def post_content(content = nil, user = admin_user)
    # post contents
    puts "---------- posting: #{content}" if @verbose
    api_call('post','contents', {:user => user.auth, :content => content})
    if (@@error && @@error.http_code==422)
      puts "*** Post content failed: 422 Unprocessable Entity"
    else
      rest_call_error("Post content failed: ")
    end
  end

  def post_response(user, response)
    # post contents
    puts "---------- posting: #{response} for #{user.email}" if @verbose
    api_call('post','user_responses', {:user => user.auth, :user_response => response})
    if (@@error)
      if (@@error.http_code==422)
        puts "*** Post failed failed: 422 Unprocessable Entity"
      return -1
      else
        rest_call_error("Post response failed: ")
      return 0
      end
    else
    return 1
    end

  end

end
