class API::V0::NotificationsController < API::V0::APIController
  before_filter  :authenticate_user_from_token!
  def index
    # get notifications for user: Notifications  manager
    notifications = notifications_manager.get_new_list(@current_user.id)
    render :json => {:success => true,:notifications => notifications.as_json}, :status=> :ok
  end

  def count
    # get contents for user: Notifications  manager
    count = notifications_manager.get_count(@current_user.id)
    render :json => {:success => true,:notifications => {user_id: @current_user.id}.merge(count)}, :status=> :ok
  end

  def content_reset
    content = notifications_manager.reset_comment_count_for_content(content_reset_params.merge({user_id:@current_user.id}))
    if content
      render :json => {:success => true,:content => content.as_json}, :status=> :ok
    else
      render :json => {:success => false, :message => "Missing or Invalid parameter(s)"}, :status=> :unprocessable_entity
    end
  end

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