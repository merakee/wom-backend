class API::V0::RegistrationsController < Devise::RegistrationsController
  #skip_before_filter :verify_authenticity_token
  before_filter :update_sanitized_params, if: :devise_controller?
  respond_to :json
  
  def create
    user = User.new(user_params)
    if user.save
      user.ensure_authentication_token!
      render :json => user.as_json(root: true, only: [:id,:user_type_id,:email,:authentication_token]), :status=>201
    return
    else
      warden.custom_failure!
      render :json => user.errors, :status=> :unprocessable_entity
    end
  end

  private

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:user_type_id, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:user_type_id, :email, :password, :password_confirmation, :current_password)}
  end

  def user_params
    params.require(:user).permit(:user_type_id, :email,:password,:password_confirmation)
  end

end
