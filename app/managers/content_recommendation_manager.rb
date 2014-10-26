class ContentRecommendationManager
  # RUN SQL
  def self.get_recomlist_for_user(user_id,count,blacklist)
    recom_list = self.get_list_from_recommder_for_user(user_id,count)
    prune_and_normalize_recomlist(recom_list,blacklist)
  end

  def self.get_list_from_recommder_for_user(user_id,count)
    # may use fixed time operation here
    begin
      Timeout.timeout(APIConstants::CONTENT_SELECTION::RECOMMENDER_TIME_OUT) do
      #recommendation_engine.recommendContent(user_id, count)
      # mock recommendation
        AppUtilManager.recommend_content(count)
      end
    rescue Timeout::Error
    []
    end
  end

  def self.prune_and_normalize_recomlist(recom_list,blacklist) 
    recom_list.select{|x| !blacklist.include?(x[0])}.map{|x| [x[0],normalize_recom_val(x[1])]}
  end

  def self.normalize_recom_val(val)
    return 0.0 if val.blank?
    if val <= APIConstants::CONTENT_SELECTION::RECOMMENDER_KILL_VAL
    0.0
    elsif val >= APIConstants::CONTENT_SELECTION::RECOMMENDER_SPREAD_VAL
    1.0
    else
      APIConstants::CONTENT_SELECTION::RECOMMENDER_NORMALIZE_SCALE*(val-APIConstants::CONTENT_SELECTION::RECOMMENDER_KILL_VAL)
    end

  end

  def self.get_recomlist_tag_for_user(user_id)
    "recomlist:uid:#{user_id}"
  end

end