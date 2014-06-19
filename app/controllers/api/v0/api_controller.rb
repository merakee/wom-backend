class API::V0::APIController < ApplicationController
  # common logic for all API controllers: along with modules 
  #http_basic_authenticate_with name:"admin", password:"password";
  respond_to :json
  
  
  def authenticate_user_or_auth_token!
    resource = User.find_for_database_authentication(:email => params[:email]) 
    if resource and resource.valid_password?(params[:password]) and      resource.valid_authentication_token?(params[:auth_token])
      return resource 
    end
    
    authenticate_user!
  end

end