class HistoryManager
  
  def get_contents(params)
    # check params
    return nil unless is_params_valid(params)
    set_default_params(params)
    Content.where(user_id: params[:user_id]).order(created_at: :desc).limit(params[:count]).offset(params[:offset])
  end
  
    def get_comments(params)
    # check params
    return nil unless is_params_valid(params)
    set_default_params(params)
    Comment.where(user_id: params[:user_id]).order(created_at: :desc).limit(params[:count]).offset(params[:offset])
  end
  
  
  def set_default_params(params)
    params[:count] = APIConstants::HISTORY::ITEM_COUNT_PER_REQUEST unless params.has_key?(:count) && params[:count] && params[:count]>0
    params[:offset] = 0 unless params.has_key?(:offset) && params[:offset] && params[:offset] >= 0
  end
  
  def is_params_valid(params)
    params.has_key?(:user_id) && params[:user_id]; 
  end 
end