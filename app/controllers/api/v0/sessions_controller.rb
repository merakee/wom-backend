class API::V0::SessionsController < Devise::SessionsController
  before_filter :authenticate_user!, :except => [:create, :destroy]
  skip_before_filter :verify_authenticity_token
  respond_to :json
  #force_ssl 
  

  def create
    resource = User.find_for_database_authentication(:email => params[:email])
    return invalid_login_attempt("invalid_userid") unless resource

    if resource.valid_password?(params[:password])
      resource.ensure_authentication_token!
      render :json=> {:success=>true, :auth_token=>resource.authentication_token, :email=>resource.email}
      return
    end
    invalid_login_attempt("invalid_password")
  end

  def destroy
    resource = User.find_for_database_authentication(:email => params[:email],:authentication_token => params[:auth_token])
    if resource && resource.authentication_token 
      resource.reset_authentication_token!
      render :json=> {:success=>true, :message=> "Authetication token deleted"}, :status => 200 
    else
      render :json=> {:success=>false, :message=> "No valid user or token"}, :status => 400
    end
  end

  protected

  def invalid_login_attempt(option=nil)
    login_err_msg = "Error with your login or password"
    login_err_msg = "Invalid user id"  if option == "invalid_userid"
    login_err_msg = "Invalid password" if option == "invalid_password"

    render :json=> {:success=>false, :message=>login_err_msg}, :status=>401
  end

end
