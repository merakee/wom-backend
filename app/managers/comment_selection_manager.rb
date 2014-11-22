class CommentSelectionManager 
  def get_comments_for_content_and_user(params)
    # check params
    return nil unless is_params_valid(params)
    set_default_params(params)
    if(params[:mode] == APIConstants::COMMENT::COMMENT_MODE_RECENT)
     comments = Comment.where(content_id: params[:content_id]).order(created_at: :desc).limit(params[:count]).offset(params[:offset])
    else
     comments = Comment.where(content_id: params[:content_id]).order(like_count: :desc, created_at: :desc).limit(params[:count]).offset(params[:offset]) 
    end
    append_user_response(params, comments)
  end
  
  def append_user_response(params, comments)
    comment_list = Comment.where(content_id: params[:content_id])
    comment_list_with_response = CommentResponse.where(user_id: params[:user_id]).where(comment_id: comment_list).pluck(:comment_id)
    comments_json = []
    comments.each{|comment|
      comment_response_hash = {did_like: comment_list_with_response.include?(comment.id)}
      #comments_json << comment.as_json(only: [:id, :user_id, :content_id, :text, :like_count, :new_like_count, :created_at, :updated_at]).merge(comment_response_hash)
     comments_json << comment.as_json.merge(comment_response_hash)
    }
    comments_json 
  end
  
  def set_default_params(params)
    params[:count] = APIConstants::COMMENT::COMMENT_COUNT_PER_REQUEST unless params.has_key?(:count) && params[:count] && params[:count]>0
    params[:mode] = APIConstants::COMMENT::COMMENT_COUNT_PER_REQUEST unless params.has_key?(:mode) && params[:mode]
    params[:offset] = 0 unless params.has_key?(:offset) && params[:offset] && params[:offset] >= 0
  end
  
  def is_params_valid(params)
    params.has_key?(:content_id) && params[:content_id] && params.has_key?(:user_id) && params[:user_id]; 
  end 
end