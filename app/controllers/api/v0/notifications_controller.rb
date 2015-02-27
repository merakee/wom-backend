class API::V0::NotificationsController < API::V0::APIController
  before_filter  :permit_only_signedin_user!
  before_filter  :authenticate_user_from_token!
  
  # Get notification list for the current user 
  # @action POST
  # @url /api/v0/notifications/getlist
  # @discussion Permitted action for only signed in user (non anonymous). Ordered from most recent to oldest. 
  # @required body
  # @response Array containing content or comments objects 
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}}
  # @example_response
  #   { "success":true,
  #     "notifications":[{ "id":540,"user_id":82,"content_id":149,"text":"Labore ab et ut doloremque quia et.","like_count":1,"new_like_count":1,"created_at":"2015-02-20T23:19:40.137Z","updated_at":"2015-02-20T23:19:40.137Z"},
  #                      { "id":149,"user_id":82,"content_category_id":1,"text":"Necessitatibus alias eum quia magni in in numquam unde aspernatur a.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-20T23:19:38.874Z","updated_at":"2015-02-20T23:19:38.874Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":21,"flag_count":0,"new_comment_count":21},
  #                      { "id":519,"user_id":82,"content_id":148,"text":"Itaque rerum facilis nihil omnis ad incidunt voluptas ut quos repellat nostrum.","like_count":1,"new_like_count":1,"created_at":"2015-02-20T23:19:38.736Z","updated_at":"2015-02-20T23:19:38.736Z"}]}
  
  def index
    # get notifications for user: Notifications  manager
    notifications = notifications_manager.get_new_list(@current_user.id)
    render :json => {:success => true,:notifications => notifications.as_json}, :status=> :ok
  end

  # Get notification counts for the current user 
  # @action POST
  # @url /api/v0/notifications/count
  # @discussion Permitted action for only signed in user (non anonymous). 
  # @required body
  # @response Array containing content or comments objects 
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"} }
  # @example_response
  #    { "success":true, "notifications":{ "user_id":82,"total_new_count":620,"new_comment_count":510,"new_like_count":110}}
  
  def count
    # get contents for user: Notifications  manager
    count = notifications_manager.get_count(@current_user.id)
    render :json => {:success => true,:notifications => {user_id: @current_user.id}.merge(count)}, :status=> :ok
  end

  # Reset content notification for the current user given content_id and count. The count should match the number obtained during get list call. 
  # @action POST
  # @url /api/v0/notifications/reset/content
  # @discussion Permitted action for only signed in user (non anonymous). 
  # @required body
  # @response Returns the content object with updated notification count
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "params": { "content_id": 149, "count": 1}}
  # @example_response
  #     { "success":true,
  #        "content":{ "id":149,"user_id":82,"content_category_id":1,"text":"Necessitatibus alias eum quia magni in in numquam unde aspernatur a.","photo_token":{ "url":null,"thumb":{ "url":null}},"total_spread":1,"spread_count":1,"kill_count":0,"created_at":"2015-02-20T23:19:38.874Z","updated_at":"2015-02-20T23:19:38.874Z","freshness_factor":1.0,"spread_efficiency":1.0,"spread_index":1.0,"comment_count":21,"flag_count":0,"new_comment_count":20}}
  
  def content_reset
    content = notifications_manager.reset_comment_count_for_content(content_reset_params.merge({user_id:@current_user.id}))
    if content
      render :json => {:success => true,:content => content.as_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity
    end
  end

  # Reset comment notification for the current user given comment_id and count. The count should match the number obtained during get list call. 
  # @action POST
  # @url /api/v0/notifications/reset/comment
  # @discussion Permitted action for only signed in user (non anonymous). 
  # @required body
  # @response Returns the comment object with updated notification count
  # @response :unprocessable_entity
  # @response :unauthorized
  # @example_request { "user": { "user_type_id": 2, "email": "test_user1@test.com", "authentication_token": "oTL6Koq5VESxbr_6K9rJ"}, "params": { "comment_id": 149, "count": 1}}
  # @example_response
  #     { "success":true,
  #       "comment":{ "id":149,"user_id":82,"content_id":40,"text":"Velit qui optio quaerat minus qui nobis optio.","like_count":1,"new_like_count":0,"created_at":"2015-02-20T23:03:27.141Z","updated_at":"2015-02-20T23:03:27.141Z"}}
  
  def comment_reset
    comment = notifications_manager.reset_like_count_for_comment(comment_reset_params.merge({user_id:@current_user.id}))
    if comment
      render :json => {:success => true,:comment => comment.as_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity
    end
  end

  private

  def content_reset_params
    params_ = params.require(:params).permit(:content_id,:count)
    convert_params_to_int(params_,[:content_id, :count])
    params_
  end

  def comment_reset_params
    params_ = params.require(:params).permit(:comment_id,:count)
    convert_params_to_int(params_,[:comment_id, :count])
    params_
  end

end