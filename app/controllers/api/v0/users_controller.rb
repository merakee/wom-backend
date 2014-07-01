class API::V0::UsersController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  #before_filter  :authenticate_api_v0_user! # :authenticate_user!  
  
  def index
    #authorize! :index, @user, :message => 'Not authorized as an administrator.'
    render :json =>  User.all
  end

  # GET /users/new
  def new
    @user = User.new
  end
  
 def show
   puts params
    if params[:id] != @current_user.id.to_s
      render :json=> {:success=>false, :message=>"Unauthorized Access"}, :status=>401
    else
      render :json => User.find(params[:id])
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
end