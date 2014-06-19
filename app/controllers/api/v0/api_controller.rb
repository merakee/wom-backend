class API::V0::APIController < ApplicationController
  # common logic for all API controllers: along with modules 
  #http_basic_authenticate_with name:"admin", password:"password";
  respond_to :json
  

end