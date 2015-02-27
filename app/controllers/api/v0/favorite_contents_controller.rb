class API::V0::FavoriteContentsController < API::V0::APIController
  before_filter  :permit_only_signedin_user!
  before_filter  :authenticate_user_from_token!
  
  # Get favorite contents list user given user id as params 
  # @action POST
  # @url /api/v0/favorite_contents/getlist
  # @discussion Permitted action for only signed in user (non anonymous). Ordered from most recent to oldest.  
  # @required body
  # @response Array containing content objects 
  # @response :unauthorized
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "params": { "user_id": 82}}
  # @example_response
  #   { "success":true,
  #     "contents":[{ "id":11,"user_id":32,"content_category_id":3,"text":"Itaque ut ea temporibus voluptate iure magnam.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:07.926Z","updated_at":"2015-02-13T21:40:07.926Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":3,"flag_count":0,"new_comment_count":3},
  #                 { "id":43,"user_id":82,"content_category_id":1,"text":"Excepturi sint est et labore sint omnis quia.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-20T23:04:13.957Z","updated_at":"2015-02-20T23:04:13.957Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1},
  #                 { "id":32,"user_id":82,"content_category_id":1,"text":"Et praesentium quos eius et quasi placeat sint ea quis unde aliquid doloremque et accusantium.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-20T22:57:47.718Z","updated_at":"2015-02-20T22:57:47.718Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":21,"flag_count":0,"new_comment_count":21},
  #                 { "id":23,"user_id":59,"content_category_id":1,"text":"Perferendis sed est ipsa enim voluptas.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-13T21:40:10.436Z","updated_at":"2015-02-13T21:40:10.436Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":1,"flag_count":0,"new_comment_count":1}]}
  
   def getlist
    # get fav contents 
    contents =favorite_content_manager.get_favorite_contents_for_user(params_getlist[:user_id])
    render :json => {:success => true,:contents => contents.as_json}, :status=> :ok
  end
  
  # Favorite a content for the current user given content id as params 
  # @action POST
  # @url /api/v0/favorite_contents/favorite
  # @discussion Permitted action for all users. User can favorite only once per content. 
  # @required body
  # @response Favorite Content Object
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "params": { "content_id": 12}}
  # @example_response
  #   { "success":true,"favorite_content":{ "id":5,"user_id":82,"content_id":12,"created_at":"2015-03-02T20:39:38.757Z"}}
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

  # Unfavorite a content for the current user given content id as params 
  # @action POST
  # @url /api/v0/favorite_contents/unfavorite
  # @discussion Permitted action for all users. User can unfavorite only already favorited content. 
  # @required body
  # @response Success message for deletion
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "params": { "content_id": 12}}
  # @example_response
  #   { "success":true,"message":"Favorite content deleted"}
  def destroy
    fcontent = FavoriteContent.where(user_id: @current_user.id,content_id: params_create[:content_id])
    render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity and return if fcontent.blank? 
   
    if fcontent.destroy_all
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
