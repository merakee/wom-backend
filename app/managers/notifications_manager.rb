class NotificationsManager
  
  # get notifications
  def get_new_list(user_id)
    return [] if user_id <= 0 
    contents = Content.where(user_id: user_id).where("new_comment_count>0")
    comments = Comment.where(user_id: user_id).where("new_like_count>0")
    # sort in descending order: no need to order the items in the DB call 
    merged_and_sorted_list = (contents + comments).sort{|item1,item2| item2.updated_at <=> item1.updated_at}
  end
  
  # get total count 
  def get_count(user_id)
    new_comment_count = Content.where(user_id: user_id).where("new_comment_count>0").sum(:new_comment_count)
    new_like_count = Comment.where(user_id: user_id).where("new_like_count>0").sum(:new_like_count) 
    {total_new_count: new_comment_count+new_like_count, new_comment_count: new_comment_count , new_like_count: new_like_count}
  end
  
  # reset content new comment count 
  def reset_comment_count_for_content(params)
    return false unless are_content_reset_params_valid(params) && are_user_and_comment_count_valid(params)
    Content.update_counters params[:content_id], :new_comment_count => -params[:count]
    Content.where(id:params[:content_id])[0]
  end
  
  def are_user_and_comment_count_valid(params)
    user_id, new_comment_count = Content.where(id:params[:content_id]).pluck(:user_id, :new_comment_count)[0]
    params[:user_id] == user_id  &&   params[:count] <= new_comment_count
  end
  
  def are_content_reset_params_valid(params)
    valid = params.has_key?(:content_id) && params[:content_id] && params[:content_id] > 0
    valid && params.has_key?(:count) && params[:count] && params[:count] > 0
  end
  
  # reset comment new like  count 
  def reset_like_count_for_comment(params)
    return false unless are_comment_reset_params_valid(params) && are_user_and_like_count_valid(params)
    Comment.update_counters params[:comment_id], :new_like_count => -params[:count]
    Comment.where(id:params[:comment_id])[0]
 end
  
  def are_user_and_like_count_valid(params)
    user_id, new_like_count = Comment.where(id:params[:comment_id]).pluck(:user_id, :new_like_count)[0]
    params[:user_id] == user_id  &&   params[:count] <= new_like_count
  end
  
  def are_comment_reset_params_valid(params)
    valid = params.has_key?(:comment_id) && params[:comment_id] && params[:comment_id] > 0
    valid && params.has_key?(:count) && params[:count] && params[:count] > 0
  end

end