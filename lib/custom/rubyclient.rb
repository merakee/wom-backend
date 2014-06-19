require 'rest_client'

base_url = 'http://localhost:3000/api/v0'

#RestClient.get base_url + '/users'

RestClient.get  base_url+'/sign_in', {:params => {:id => 'user1', :password => 'password'}}