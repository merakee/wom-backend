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
# all sources of content 
require '../BuzzFeed/BuzzFeed_RSS.rb'

@is_local = true 
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

def base_url
  aws_path = 'http://wom-backend-master-env-ujwc9jrchq.elasticbeanstalk.com/'
  local_path = 'http://localhost:3000/'
  api_path = 'api/v0/'
  @is_local?(local_path + api_path): (aws_path + api_path)
end

def api_path(path)
  base_url+path
end

@response = nil 
@error = nil 
@success = false
@admin_user = nil

# rest calls
def rest_call(verb='post',path='',data={})
  begin
    response = RestClient.post path, data.to_json,  :content_type => :json, :accept => :json     if verb=='post'
    response = RestClient.get  path, data.to_json, :content_type => :json, :accept => :json     if verb=='get'
    response = RestClient.get  path,  data   if verb=='get'
    response = RestClient.delete  path, data.to_json,  :content_type => :json, :accept => :json     if verb=='delete'
    @response = JSON::parse(response)
    @success = true
    @success = @response['success'] if @response['success'].nil?


  rescue => error
    @error = error 
    @success = false
  end
end

def rest_call_error(msg="Something went wrong: ")
  if !@success
    reason = @response['message'] if (defined? @response['message'])
    reason = @error.to_s if reason.nil?
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
class AdminUser
  attr_reader :email, :password, :password_confirmation, :user_type_id
  attr_accessor :authentication_token
  def initialize
    @email = "admin@system.com"
    @password = "adminpassword"
    @password_confirmation = @password
    @user_type_id = 2
    @authentication_token = nil 
  end

  def to_json
    {:user_type_id => @user_type_id, :email => @email, :password => @password, :password_confirmation => @password_confirmation,:authentication_token => @authentication_token}
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
  @admin_user || @admin_user=AdminUser.new
end

def sign_up_user(user = admin_user)
  api_call('post','sign_up',{:user => user.sign_up})
  user.authentication_token = @response['user']['authentication_token'] if @success
  if @error && @error.http_code==422
    sign_in_user
  else 
    rest_call_error("Sign up failed: ") 
  end
end

def sign_in_user(user = admin_user)
# User Session: sign_in
api_call('post','sign_in',{:user => user.sign_in})
user.authentication_token = @response['user']['authentication_token'] if @success
rest_call_error("Sign in failed: ")  
end

def create_content(text=nil, category = 1)
 {:content_category_id => category, :text => text}
end

def post_content(content = nil, user = admin_user)
# post contents
  puts "---------- posting: #{content}"
  api_call('post','contents', {:user => user.auth, :content => content})
  if (@error && @error.http_code==422) 
    puts "*** Post content failed: 422 Unprocessable Entity"
  else
    rest_call_error("Post content failed: ")
  end
end

# sign up/sign_in user
sign_up_user 

# get feed from buzzfeed
feed = get_buzzfeed()

# post feed
feed.each { |text|
  post_content(create_content(text))
}



