#
#
#
#
#

require 'rest_client'
require 'json'
require 'base64'

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
  #aws_path = 'http://wom-backend-master-env-hv2gxttyvi.elasticbeanstalk.com/'
  #aws_path = 'http://wom.freelogue.net/'
  local_path = 'http://localhost:3000/'
  api_path = 'api/v0/'
  base_url = local_path + api_path
end

def api_path(path)
  base_url+path
end

@response = {}
@success = false
@message = {}
@user = nil

# rest calls
def rest_call(verb='post',path='',data={})
  begin
    response = RestClient.post path, data.to_json,  :content_type => :json, :accept => :json     if verb=='post'
    #response = RestClient.get  path, data.to_json, :content_type => :json, :accept => :json     if verb=='get'
    response = RestClient.get  path,  data   if verb=='get'
    response = RestClient.delete  path, data.to_json,  :content_type => :json, :accept => :json     if verb=='delete'
  rescue => error
    puts error
  end

  if(response)
    @response = JSON::parse(response)
    if  @response.class==Hash.class && @response.has_kay?('success')
      @success = @response['success']
    else
      @success = true
    end
  else
    if defined? error.response
      @response = JSON::parse(error.response)
      @response  = error.to_s if @response.empty?
      if @response.class==Hash.class && @response.has_kay?('success')
        @success = @response['success']
      else
        @success = true
      end

    else
      @response = error.to_s
      @success = false
    end

  end

end

def rest_call_error(msg="Something went wrong: ")
  if !@success
    puts @response['message']
    reason = (defined? @response['message'])?@response['message']:@response
    puts msg +  @response
    puts 'Exiting.........................'
    exit
  end
end

# API calls

def api_call(verb='post',path='',data={})
  rest_call(verb,api_path(path),data)
end
# User Session: sign_up
api_call('post','sign_up',{:user => {:user_type_id => 2, :email => 'me@me.com', :password => 'password',:password_confirmation => 'password'}})
@user = @response['user'] if @success
puts @response# if !@success

# User Session: sign_in
api_call('post','sign_in',{:user => {:email => 'me@me.com', :password => 'password'}})
@user = @response['user'] if @success
rest_call_error("Sign in failed: ")

puts @user 
# get content
# api_call('get','contents', :params => {:user => {:email => @user['email'], :authentication_token => @user['authentication_token']}}) if @user
# rest_call_error("Get Content Failed: ")
# 
# @response['contents'].each {|content|
  # puts content['id'].to_s + ': '+ content['text']
# }


# content creation
def get_content(category = 1, text="This Is Fun", photo_token = nil)
  filename = "bg#{rand(4)+1}.jpg"
  text = text + " with number #{rand(100000)+1}"
 {:content_category_id => category, :text => text, :photo_token => #File.new("./../../spec/fixtures/content_photos/#{filename}", 'rb')
  {
   file: Base64.encode64(File.new("./../../spec/fixtures/content_photos/#{filename}", 'rb').read),
   filename:"file.jpg",
   content_type: "image/jpeg"}
   }
end

def get_content_text_only(category = 1, text="This Is Fun", photo_token = nil)
  text = text + " with number #{rand(100000)+1}"
 {:content_category_id => category, :text => text, :photo_token => photo_token}
end

# post contents
content = get_content_text_only
api_call('post','contents', {:user => {:email => @user['email'], :authentication_token => @user['authentication_token']}, :content => content, :multipart => true }) if @user

puts @response

# # get content from feedzille
# def feedzilla_path(path)
# feedzilla_url = "http://api.feedzilla.com/v1/"
# feedzilla_url+path
# end
#
# def feedzilla_call(verb='post',path='',data=nil)
# rest_call(verb,feedzilla_path(path),data)
# end
#
# #feedzilla_call('get','categories.json')
# feedzilla_call('get','categories/26/articles.json?count=200')
# #puts  @response  if @success
# rest_call_error("Could not get content from FeedZilla: ")
#
# @response['articles'].each{|content|
# title = content['title'].strip!
# title ="No title" if title.nil?
# sum =  content['summary'].strip!
# sum ="No summary" if sum.nil?
#
# puts title +  ": " + sum  + "\n"
#
# }
