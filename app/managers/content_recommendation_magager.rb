class ContentRecommendationManager

  # RUN SQL
  def get_recomlist_for_user(user_id,count,blacklist)
    # get tag
    # get list
    # Fixed size: set constant

    # check exsistence
    # if does not exist ask Rcom Engine
    # set ttl
  end

  def get_recomlist_tag_for_user(user_id)
    "recomlist:uid:#{user_id}"
  end

end