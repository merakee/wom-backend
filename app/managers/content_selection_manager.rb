class ContentSelectionManager
  
  def self.get_contents_for_user(user_id)
    # select list of content for user with :id
    offset = [rand(Content.count)-APIConstants::CONTENT::RESPONSE_SIZE, 0].max
    contents = Content.limit(APIConstants::CONTENT::RESPONSE_SIZE).offset(offset)
  end

end