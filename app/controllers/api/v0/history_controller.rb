class API::V0::HistoryController < API::V0::APIController
  before_filter  :permit_only_signedin_user!
  before_filter  :authenticate_user_from_token!
  
  # Get content history for the current user given optional parameters: count (default 10), and offset (default 0)
  # @action POST
  # @url /api/v0/history/contents
  # @discussion Permitted action for only signed in user (non anonymous). Ordered from most recent to oldest. 
  # @required body
  # @response Array containing content objects 
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "params": { "count": 10, "offset": 0}}
  # @example_response
  #   { "success":true,
  #     "contents":[{ "id":151,"user_id":82,"content_category_id":1,"text":"This is a content with image","photo_token":{ "url":"https://wombackend-dev-freelogue.s3.amazonaws.com/uploads/content/photo_token/151/file.jpg?AWSAccessKeyId=AKIAJ66HRUSQUNFK7PXA\u0026Signature=TVcT/hDHA97fHwMxT5CEvUuz02o%3D\u0026Expires=1425333418","thumb":{ "url":"https://wombackend-dev-freelogue.s3.amazonaws.com/uploads/content/photo_token/151/thumb_file.jpg?AWSAccessKeyId=AKIAJ66HRUSQUNFK7PXA\u0026Signature=YVxJupVOPgMDLC5Q3P0jZZPkBxw%3D\u0026Expires=1425333418"}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-03-02T21:12:45.272Z","updated_at":"2015-03-02T21:12:45.272Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":0,"flag_count":0,"new_comment_count":0},
  #                 { "id":150,"user_id":82,"content_category_id":1,"text":"This is a text only content","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-03-02T21:07:01.116Z","updated_at":"2015-03-02T21:07:01.116Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":0,"flag_count":0,"new_comment_count":0},
  #                 { "id":149,"user_id":82,"content_category_id":1,"text":"Necessitatibus alias eum quia magni in in numquam unde aspernatur a.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-20T23:19:38.874Z","updated_at":"2015-02-20T23:19:38.874Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":21,"flag_count":0,"new_comment_count":21}]}
  def contents
    # get contents for user: History  manager
    contents = history_manager.get_contents(history_params.merge({user_id:@current_user.id}))
    if(contents)
      render :json => {:success => true,:contents => contents.as_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity
    end
  end

  # Get comment history for the current user given optional parameters: count (default 10), and offset (default 0)
  # @action POST
  # @url /api/v0/history/comments
  # @discussion Permitted action for only signed in user (non anonymous). Ordered from most recent to oldest. 
  # @required body
  # @response Array containing comment objects 
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "params": { "count": 82, "offset": 0}}
  # @example_response
  #   { "success":true,
  #     "comments":[{ "id":542,"user_id":82,"content_id":12,"text":"Nice pic","like_count":0,"new_like_count":0,"created_at":"2015-03-02T21:32:44.640Z","updated_at":"2015-03-02T21:32:44.640Z"},
  #                 { "id":541,"user_id":82,"content_id":12,"text":"this is a nice pic","like_count":0,"new_like_count":0,"created_at":"2015-03-02T20:30:30.208Z","updated_at":"2015-03-02T20:30:30.208Z"}]}
  
  def comments
    # get contents for user: History  manager
    comments = history_manager.get_comments(history_params.merge({user_id:@current_user.id}))
    if(comments)
      render :json => {:success => true,:comments => comments.as_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity
    end
  end

  private

  def history_params
    params_ = params.require(:params).permit(:count,:offset)
    convert_params_to_int(params_,[:count,:offset])
    params_
  end

end