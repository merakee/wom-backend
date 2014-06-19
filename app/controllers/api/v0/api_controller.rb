class API::V0::APIController < ApplicationController
  # common logic for all API controllers: along with modules
  #http_basic_authenticate_with name:"admin", password:"password";
  respond_to :json
  
  
  def authenticate_user_or_auth_token!
    user  = User.find_for_database_authentication(:email => params[:email])
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    return user if user && Devise.secure_compare(user.authentication_token, params[:auth_token])
    authenticate_user!
  end

end