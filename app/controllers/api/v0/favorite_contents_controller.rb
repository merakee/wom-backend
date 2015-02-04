class API::V0::FavoriteContentsController < API::V0::APIController
  before_filter  :permit_only_signedin_user!
  before_filter  :authenticate_user_from_token!
  
   def getlist
    # get fav contents 
    contents =favorite_content_manager.get_favorite_contents_for_user(params_getlist(:user_id))
    render :json => {:success => true,:contents => contents.as_json}, :status=> :ok
  end
  
  def create
    # add new response to db
    fcontent = FavoriteContent.new(params_create)
    fcontent.user_id = @current_user.id
    if fcontent.save
      render :json => {:success => true, :favorite_content => fcontent.as_json}, :status=> :created #201
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (fcontent.errors.as_json)}, :status=> :unprocessable_entity
    end
  end


  def destroy
    fcontent = FavoriteContent.where(user_id: @current_user.id,content_id: params_create(:content_id))
    render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity and return if fcontent.blank? 
   
    if fcontent.destroy 
      render :json=> {:success=>true, :message=> "Favorite content deleted"}, :status => :ok #200
    else
      render :json=> {:success=>false, :message=> "Unauthorized user"}, :status =>   :bad_request # 400
    end
  end
  
  private

  def params_getlist
    params.require(:params).permit(:user_id)  
  end
  
  def params_create
    params.require(:params).permit(:content_id)  
  end

end
