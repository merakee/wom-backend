class API::V0::RegistrationsController < Devise::RegistrationsController
  #skip_before_filter :verify_authenticity_token
  before_filter :update_sanitized_params, if: :devise_controller?
  respond_to :json
  
  def create
    case  user_type_params
    # anonymous
    when "1"||1
      anonymous_user_sign_up
    # regular
    when "2"||2
      wom_user_sign_up
    # other
    else
    render :json=> {:success=>false, :message=>"Unkown user type"}, :status=> :unprocessable_entity
    end
  end

  private
  def anonymous_user_sign_up
    params[:user][:password] = "passowrd"
    params[:user][:password_confirmation] =params[:user][:password]
    user = User.new(user_params)
    user.set_anonymous_user
    add_user(user)
  end

  def wom_user_sign_up
    user = User.new(user_params)
    add_user(user)
  end

  def add_user(user)
    
    if user.save
      user.ensure_authentication_token!
      render :json => user.as_json(root: true, only: [:id,:user_type_id,:email,:authentication_token]), :status=>201
    return
    else
      warden.custom_failure!
      render :json => user.errors, :status=> :unprocessable_entity
    end
  end


  
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:user_type_id, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:user_type_id, :email, :password, :password_confirmation, :current_password)}
  end

  def user_type_params
    params.require(:user).require(:user_type_id)
  end

  def user_params
    params.require(:user).permit(:user_type_id, :email,:password,:password_confirmation)
  end

end
