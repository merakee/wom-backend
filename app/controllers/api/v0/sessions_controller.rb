class API::V0::SessionsController < Devise::SessionsController
  #before_filter :authenticate_api_v0_user!#, :except => [:create]
  #skip_before_filter :verify_authenticity_token
  before_filter :ensure_params_exist
  respond_to :json
  #force_ssl
  def create
    user = User.find_for_database_authentication(:email => params[:user][:email])
    return invalid_login_attempt("invalid_userid") unless user

    if user.valid_password?(params[:user][:password])
      user.ensure_authentication_token!
      #render :json=> {:success=>true, :authentication_token=>user.authentication_token, :email=>user.email}
      render :json=> {:success=>true, user:{id: user.id,
        authentication_token: user.authentication_token, email:user.email}} , 
        :status => :ok #200
    return
    end
    invalid_login_attempt("invalid_password")
  end

  def destroy
    user = User.find_for_database_authentication(:email => params[:user][:email],:authentication_token => params[:user][:authentication_token])
    if user && user.authentication_token
      user.reset_authentication_token!
      render :json=> {:success=>true, :message=> "Authetication token deleted"}, :status => :ok #200
    else
      render :json=> {:success=>false, :message=> "Not valid user or token"}, :status =>   :bad_request # 400
    end
  end

  private
  def ensure_params_exist
    return unless params[:user].blank? || params[:user][:email].blank?
    render :json=>{:success=>false, :message=>"Missing login email parameter"}, :status => :unprocessable_entity #422
  end

  def invalid_login_attempt(option=nil)
    warden.custom_failure!
    login_err_msg = "Error with your login or password"
    login_err_msg = "Invalid user id"  if option == "invalid_userid"
    login_err_msg = "Invalid password" if option == "invalid_password"

    render :json=> {:success=>false, :message=>login_err_msg}, :status=> :unauthorized # 401
  end

end
