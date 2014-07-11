class API::V0::UsersController < API::V0::APIController
  before_filter  :authenticate_user_from_token!


  api :GET,  '/profile', "Show user profile info"
  #api_versions
  api_version "0.0"
  formats ['json']
  param_group :user_auth, API::V0::APIController
  #param
  description "Show profile information for the autheticated user"
  error :code => 401, :desc => "Unauthorized", :meta => "Invalid user email and authetication token"
  error :code => 422, :desc => "Unprocessable Entity", :meta => "Missing required params"
  example "{'user':{'id':123,'user_type_id':2,'email':wom_user@example.com}}"
  #see
  #meta
 
  def show
    return if invalid_action_for_anonymous_user?(@current_user)
    render :json => {:success => true, :user =>(@current_user.as_json(:only =>[:id, :user_type_id, :email]))}, :status=> :ok #200
  end

# def update
# authorize! :update, @user, :message => 'Not authorized as an administrator.'
# @user = User.find(params[:id])
# if @user.update_attributes(params[:user], :as => :admin)
# redirect_to users_path, :notice => "User updated."
# else
# redirect_to users_path, :alert => "Unable to update user."
# end
# end
#
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
end