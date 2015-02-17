class FavoriteContentManager
  
  # selection manager
  def get_favorite_contents_for_user(user_id)
    content_ids = FavoriteContent.where(user_id: user_id).order(created_at: :desc).limit(APIConstants::FAVORITES::TOTAL_MAX_FAVORITES).pluck(:content_id)
    contents = Content.where(id: content_ids)
    # make sure the oder is same as the content_ids order 
    content_ids.collect {|cid| contents.detect {|content| content.id == cid}}
  end

end