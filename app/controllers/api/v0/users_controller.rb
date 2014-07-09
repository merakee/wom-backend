class API::V0::UsersController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  def show
    return if invalid_action_for_anonymous_user?(@current_user)
    render :json => @current_user.as_json(root: true), :status=> :ok #200
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