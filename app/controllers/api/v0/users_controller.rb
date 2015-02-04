class API::V0::UsersController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  
  
  def profile
    # get user info 
    user = User.where(id:params_profile[:user_id])[0]
    if content   
      render :json => {:success => true, :user => user.as_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Invalid user id"}, :status=> :unprocessable_entity
    end
  end

  # Update user profile for signed in user
  # @action POST
  # @url /api/v0/users/update
  # @required user [Hash] user hash with user email and auth token
  # @optional profile [Hash] profile hash with  :user_name,:height,:weight
  # @response [Json] user profile object
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