class API::V0::CommentsController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  
  # Get comment list for content given content_id (required) and optional parameters: mode (recent or popular, default recent), count (default 10), and offset (default 0)
  # @action POST
  # @url /api/v0/comments/getlist
  # @discussion Permitted action for all users.
  # @required body
  # @response Array containing comment objects 
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request  { { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "params": { "content_id": 12, "mode": "recent", "count": 10, "offset": 0} }
  # @example_response
  #    { "success":true,
  #     "comments":[{ "id":542,"user_id":82,"content_id":12,"text":"Nice pic","like_count":0,"new_like_count":0,"created_at":"2015-03-02T21:32:44.640Z","updated_at":"2015-03-02T21:32:44.640Z","did_like":false},
  #                 { "id":541,"user_id":82,"content_id":12,"text":"this is a nice pic","like_count":0,"new_like_count":0,"created_at":"2015-03-02T20:30:30.208Z","updated_at":"2015-03-02T20:30:30.208Z","did_like":false},
  #                 { "id":2,"user_id":33,"content_id":12,"text":"Qui exercitationem doloribus porro explicabo doloremque voluptatem architecto.","like_count":0,"new_like_count":0,"created_at":"2015-02-13T21:40:08.220Z","updated_at":"2015-02-13T21:40:08.220Z","did_like":false}]}
  
  def index
    # get comment for user: comment selection manager
    # returns either an array of hash or nil
    # each has contains these keys: [:id, :user_id, :comment_id, :text, :like_count, :created_at, :did_like]
    comments_json = comment_selection_manager.get_comments_for_content_and_user(comment_params_for_list.merge({user_id:@current_user.id}))
    if(comments_json)
      render :json => {:success => true,:comments => comments_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity
    end
  end

  # Save comment for user given comment params
  # @action POST
  # @url /api/v0/comments/create
  # @discussion Permitted action for only signed in user (non anonymous). 
  # @required body
  # @response A comment object 
  # @response :unauthorized
  # @response :unprocessable_entity
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "comment": { "content_id": 12, "text": "Nice pic"}}
  # @example_response 
  #   { "success":true,
  #     "comment":{ "id":542,"user_id":82,"content_id":12,"text":"Nice pic","like_count":0,"new_like_count":0,"created_at":"2015-03-02T21:32:44.640Z","updated_at":"2015-03-02T21:32:44.640Z"}}

  def create
    return if invalid_action_for_anonymous_user?(@current_user)    
    # add new comment
    comment = Comment.new(comment_params_for_create)
    comment.user_id = @current_user.id
    if comment.save
      #render :json => {:success => true,:comment => (comment.as_json(only: select_keys_for_comment))}, :status=> :created
      render :json => {:success => true,:comment => comment.as_json}, :status=> :created
    else
      warden.custom_failure!
      render :json => {:success => false, :message => (comment.errors.as_json)}, :status=> :unprocessable_entity
    end
  end

  private

  def comment_params_for_create
    params.require(:comment).permit(:content_id,:text)
  end

  def comment_params_for_list
    params_ = params.require(:params).permit(:content_id,:mode,:count,:offset)
    convert_params_to_int(params_,[:content_id,:count,:offset])
    params_
  end

end