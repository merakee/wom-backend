class API::V0::UsersController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  
  # Get user profile for given user id
  # @action POST
  # @url /api/v0/users/profile
  # @discussion Permitted action for only signed in user (non anonymous)
  # @required body  
  # @response User Profile Object 
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user" :  { "user_type_id" :  2, "email" :  "test_user1@test.com", "authentication_token" :  "oTL6Koq5VESxbr_6K9rJ"}, "params" :  { "user_id" :  2}}
  # @example_response 
  #   { "success":true,
  #     "user":{
  #       "id":2,
  #       "user_type_id":2,
  #       "nickname":"user101",
  #       "avatar":{ "url":"https://wombackend-dev-freelogue.s3.amazonaws.com/uploads/user/avatar/2/avatar.jpg?AWSAccessKeyId=AKIAJ66HRUSQUNFK7PXA\u0026Signature=iTIrdKjexUeXkILP432d%2B4rVPPs%3D\u0026Expires=1425075503",
  #       "thumb":{ "url":"https://wombackend-dev-freelogue.s3.amazonaws.com/uploads/user/avatar/2/thumb_avatar.jpg?AWSAccessKeyId=AKIAJ66HRUSQUNFK7PXA\u0026Signature=umdziFvkPVQXWDqX2/PBRr24MoA%3D\u0026Expires=1425075503"}},
  #       "bio":" ",
  #       "social_tags":["twitter:username"],
  #       "hometown":"mytown"}}
      
  def profile
    # get user info 
    user = User.where(id:params_profile[:user_id])[0]
    if user  
      render :json => {:success => true, :user => user.as_json(only: [:id,:user_type_id,:nickname,:avatar,:bio,:social_tags,:hometown])}, :status=> :ok
    else
      render :json => {:success => false, :message => "Invalid user id"}, :status=> :unprocessable_entity
    end
  end

  # Update user profile for signed in user
  # @action POST
  # @url /api/v0/users/update
  # @discussion Permitted action for only signed in user (non anonymous)
  # @required body  
  # @response User Object 
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request 
  #  { "user" :  { "user_type_id" :  2, "email" :  "test_user1@test.com", "authentication_token" :  "oTL6Koq5VESxbr_6K9rJ"}, 
  #    "params": { email:"newEmail",
  #                password: "newPassowrd",
  #                password_confirmation: "newPassowrdConfirmation",
  #                nickname:"newNickname",
  #                "avatar":"newAvatar -base64 coded",
  #                "bio":"new bio",
  #                "social_tags":["kay1:val1","kay2:val2"],
  #                "hometown":"mytown"  }}
  # @example_response 
  #   { "success":true,
  #      "user":{ 
  #               "id":82,
  #               "email":"test_user1@test.com",
  #               "authentication_token":"oTL6Koq5VESxbr_6K9rJ",
  #               "nickname":"newNickname",
  #               "user_type_id":2,
  #               "created_at":"2015-02-20T21:26:46.478Z",
  #               "updated_at":"2015-02-20T23:19:40.181Z",
  #               "avatar":{ "url":"https://wombackend-dev-freelogue.s3.amazonaws.com/uploads/user/avatar/82/avatar.jpg?AWSAccessKeyId=AKIAJ66HRUSQUNFK7PXA\u0026Signature=dCo9iin9CxOrO5G51KoF0%2B8t234%3D\u0026Expires=1425071229",
  #               "thumb":{ "url":"https://wombackend-dev-freelogue.s3.amazonaws.com/uploads/user/avatar/82/thumb_avatar.jpg?AWSAccessKeyId=AKIAJ66HRUSQUNFK7PXA\u0026Signature=JldttOSc0okqnLJlt4cCj29Tykk%3D\u0026Expires=1425071229"}},
  #               "bio":"new bio",
  #               "social_tags":["kay1:val1","kay2:val2"],
  #               "hometown":"mytown"  }}
  
  def update
    return if invalid_action_for_anonymous_user?(@current_user)
    # update current user
    user=@current_user 
    if user.update(params_update)
      render :json => {success:  true, :user => user.as_json}, status:  :ok #200
    else
      warden.custom_failure!
      render :json => {success:  false, message:  (user.errors.as_json)}, status:  :unprocessable_entity
    end
    
    ensure
      clean_tempfile
  end

  
  # def destroy
  # authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
  # user = User.find(params[:id])
  # unless user == current_user
  # user.destroy
  # redirect_to users_path, :notice => "User deleted."
  # else
  # redirect_to users_path, :notice => "Can't delete yourself."
  # end
  # end

  private

  def params_profile
    params.require(:params).permit(:user_id)
  end
  
  def params_update
    process_avatar_params(params[:user][:avatar]) unless params[:user].nil? 
    params.require(:params).permit(:nickname,:email,:password,:password_confirmation,:avatar,:bio,:social_tags,:hometown)
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