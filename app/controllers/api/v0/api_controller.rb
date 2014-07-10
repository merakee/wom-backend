class API::V0::APIController < ApplicationController
  # common logic for all API controllers: along with modules
  #http_basic_authenticate_with name:"admin", password:"password";
  
 # apipie doc
  def_param_group :user_auth do
    param :user, Hash, :desc => "User Authetication" , :required => true do
      param :email, String, :desc => "User Email", :required => true
      param :authentication_token, String, :desc => "Authentication Token", :required => true
    end
  end
  def_param_group :user_sign_up do
    param :user, Hash, :desc => "User Sign Up" , :required => true do
      param :user_type_id, Integer, :desc => "User Type Id", :required => true
      param :email, String, :desc => "Email for signing up", :required => true, :meta => "Excpet for Anonymous User"
      param :password, String, :desc => "Password", :required => true, :meta => "Excpet for Anonymous User"
      param :password_confirmation, String, :desc => "Password Comfirmation. Must match password", :required => true, :meta => "Excpet for Anonymous User"
    end
  end

  def_param_group :user_sign_in do
    param :user, Hash, :desc => "User Sign In" , :required => true do
      param :email, String, :desc => "Email for signing in", :required => true
      param :password, String, :desc => "Password", :required => true
    end
  end
  
  # end 
  
  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    error = {}
    error[parameter_missing_exception.param] = ['parameter is required']
    response = { errors: [error] }
    respond_to do |format|
      format.json { render json: response, status: :unprocessable_entity }
    end
  end

  private

 def authenticate_user_from_token!
    @current_user  = User.find_for_database_authentication(:email => user_params[:email])
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    return @current_user if @current_user && Devise.secure_compare(@current_user.authentication_token, user_params[:authentication_token])
    authenticate_api_v0_user!
  end

  def user_params
    params.require(:user).permit(:email,:authentication_token)
  end


end

=begin
  apipie Method------
 api_versions
 api_version
 param
 formats
 error
 description
 example
 see
 meta
 
 apipie param --------
 name
 validator
 desc
 required
 allow_nil
 as
 meta
 show 
=end