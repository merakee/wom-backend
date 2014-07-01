class API::V0::APIController < ApplicationController
  # common logic for all API controllers: along with modules
  #http_basic_authenticate_with name:"admin", password:"password";

  private
  def authenticate_user_from_token!    
    @current_user  = User.find_for_database_authentication(:email => params[:email])
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    return @current_user if @current_user && Devise.secure_compare(@current_user.authentication_token, params[:authentication_token])
    authenticate_api_v0_user!
  end

end