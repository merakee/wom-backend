class API::V0::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token
  before_filter :update_sanitized_params, if: :devise_controller?
  respond_to :json
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name, :email, :password, :password_confirmation, :current_password)}
  end

  def create
    #puts params
    #user = User.new(params[:user])
    user = User.new(user_params)
    if user.save
      user.ensure_authentication_token!
      render :json => user.as_json(:authentication_token=>user.authentication_token, :email=>user.email), :status=>201
    return
    else
      warden.custom_failure!
      render :json => user.errors, :status=>422
    end
  end

  private
  def user_params
    params.require(:user).permit(:name,:email,:password)
  end

end
