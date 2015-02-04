class API::V0::APIController < ApplicationController
  # common logic for all API controllers: along with modules
  #http_basic_authenticate_with name:"admin", password:"password";

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    errors = {}
    errors[parameter_missing_exception.param] = ['parameter is required']
    render :json => {:success => false, :message => (errors.as_json)}, :status=> :unprocessable_entity
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

  def permit_only_signedin_user!
    is_signedin_user = user_params.has_key?(:user_type_id) && user_params[:user_type_id] && (user_params[:user_type_id] == 2 || user_params[:user_type_id] == "2")  
    render :json=> {:success=>false, :message=> "Not a valid action for this user"}, :status =>   :bad_request unless is_signedin_user
  end

  def user_params
    params.require(:user).permit(:email,:authentication_token,:user_type_id)
  end

end