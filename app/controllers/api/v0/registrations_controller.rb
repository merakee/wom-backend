class API::V0::RegistrationsController < Devise::RegistrationsController
  #skip_before_filter :verify_authenticity_token
  before_filter :update_sanitized_params, if: :devise_controller?
  respond_to :json
  
  # Sign up user
  # @action POST
  # @url /api/v0/signup
  # @discussion Permitted action for all users. 
  # @required body  
  # @response User Object 
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request 
  #   * For normal user: { "user" :  { "user_type_id" :  2, "email" :  "example1@me.com", "password" :  "password", "password_confirmation" :  "password", "nickname":"usernickname", "avatar": { "file": " image file converted to string with base64 code", "filename": "file.jpg", "content_type": "image/jpeg"}}}}
  #   * For Anonymous user: { "user": { "user_type_id" :  1, "email" :  " ", "password" :  " ", "password_confirmation" :  " "}}
  # @example_response 
  #   { "success":true,
  #     "user":{ 
  #       "id":92,
  #       "email":"example1@me.com",
  #       "authentication_token":"kYpsay_xzp2nVBzVuMaB",
  #       "nickname":"Anonymous",
  #       "user_type_id":2,
  #       "created_at":"2015-02-27T21:39:10.730Z",
  #       "updated_at":"2015-02-27T21:39:10.730Z",
  #       "avatar":{ "url":"https://wombackend-dev-freelogue.s3.amazonaws.com/uploads/user/avatar/avatar.jpg?AWSAccessKeyId=AKIAJ66HRUSQUNFK7PXA\u0026Signature=BHblcuLHC%2B1ym4T35b2GD1iLJhA%3D\u0026Expires=1425073750",
  #       "thumb":{ "url":"https://wombackend-dev-freelogue.s3.amazonaws.com/uploads/user/avatar/thumb_avatar.jpg?AWSAccessKeyId=AKIAJ66HRUSQUNFK7PXA\u0026Signature=Lq%2BKftpDoWT2g4ZKETEUEPmis%2BE%3D\u0026Expires=1425073750"}},
  #       "bio":" ",
  #       "social_tags":[],
  #       "hometown":" "}}
  #
  
  def create
    case  user_type_params

    # anonymous
    when APIConstants::API_USER_TYPE::ANONYMOUS, APIConstants::API_USER_TYPE::ANONYMOUS.to_s
      anonymous_user_sign_up
    # regular
    when APIConstants::API_USER_TYPE::WOM, APIConstants::API_USER_TYPE::WOM.to_s
      wom_user_sign_up
    # other
    else
    render :json=> {:success=>false, :message=>"Unknown user type"}, :status=> :unprocessable_entity
    end
  end

  private

  def anonymous_user_sign_up
    params[:user][:password] = "passowrd"
    params[:user][:password_confirmation] =params[:user][:password]
    params[:user][:nickname] = "Anonymous"
    #params[:user][:avatar] = "avatar.jpg"
    #params[:user][:bio] = "bio"
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
      #render :json => {:success => true, :user => user.as_json(only: [:id,:user_type_id,:email,:authentication_token])}, :status=> :created
      render :json => {:success => true, :user => user.as_json}, :status=> :created
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (user.errors.as_json)}, :status=> :unprocessable_entity
    end

  ensure
    clean_tempfile

  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:user_type_id, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:user_type_id, :email, :password, :password_confirmation, :current_password)}
  end

  def user_type_params
    params.require(:user).require(:user_type_id)
  end

  def user_params
    process_avatar_params(params[:user][:avatar]) unless params[:user].nil?
    params.require(:user).permit(:user_type_id, :email,:password,:password_confirmation,:nickname,:avatar,:bio,:social_tags,:hometown)
  end

  def process_avatar_params(avatar)
    if avatar && avatar[:file]
      @tempfile = Tempfile.new('user_photo')
      @tempfile.binmode
      @tempfile.write Base64.decode64(avatar[:file])
      @tempfile.rewind

      params[:content][:avatar] = ActionDispatch::Http::UploadedFile.new(
      :tempfile => @tempfile,
      :content_type => avatar[:content_type],
      :filename => avatar[:filename])
    end

  end

  def clean_tempfile
    # clean up tempfile user for params processing
    # close! closes and deletes (unlicks) the file
    @tempfile.close!  if @tempfile
  end

end
