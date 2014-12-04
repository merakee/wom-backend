class ContentRecommendationManager
  def initialize
    @redis = DataStore.redis
    #@recommendation_engine = WomClient.new
    # new recommender client
    @recommendation_engine = RecommendationClient.new
  end

  # RUN SQL
  def get_recomlist_for_user(user_id,count=APIConstants::CONTENT_SELECTION::CONTENT_COUNT_PER_REQUEST,blacklist=[])
    recom_list = get_recommendation_list(user_id,count,blacklist)
    normalize_recomlist(recom_list)
  end

  def get_recommendation_list(user_id,count,blacklist)
    key  = get_recomlist_tag_for_user(user_id)
    if @redis.exists(key)
      prune_recomlist(get_recomlist_from_datastore(key,count),blacklist)
    else
      recom_list = prune_recomlist(get_list_from_recommder_for_user(user_id,APIConstants::CONTENT_SELECTION::RECOMMENDER_RECOMMENDATION_SIZE),blacklist)
      save_recomlist_in_datastore(key,recom_list)
    recom_list[0..count-1]
    end
  end

  def prune_recomlist(recom_list,blacklist)
    return recom_list if blacklist.blank?
    recom_list.reject{|x| blacklist.include?(x[0])}
  end

  def normalize_recomlist(recom_list)
    recom_list.map{|x| [x[0],normalize_recom_val(x[1])]}
  end

  def normalize_recom_val(val)
    return 0.0 if val.blank?
    if val <= APIConstants::CONTENT_SELECTION::RECOMMENDER_KILL_VAL
    0.0
    elsif val >= APIConstants::CONTENT_SELECTION::RECOMMENDER_SPREAD_VAL
    1.0
    else
      APIConstants::CONTENT_SELECTION::RECOMMENDER_NORMALIZE_SCALE*(val-APIConstants::CONTENT_SELECTION::RECOMMENDER_KILL_VAL)
    end

  end

  # recom engine
  def get_list_from_recommder_for_user(user_id,count)
    # may use fixed time operation here
    begin
      Timeout.timeout(APIConstants::CONTENT_SELECTION::RECOMMENDER_TIME_OUT) do
      #@recommendation_engine.recommendContent(user_id, count)
      # new recommender client
        @recommendation_engine.get_recommendation_for_user(user_id, count)
      # mock recommendation
      # AppUtilManager.recommend_content(count)
      end
    rescue Timeout::Error
    []
    end
  end

  # data store methods
  def save_recomlist_in_datastore(key,recom_list)
    return if recom_list.blank?
    # push list
    @redis.rpush(key, recom_list)
    # set ttl
    @redis.expire(key,APIConstants::CONTENT_SELECTION::RECOMMENDER_RECOMMENDATION_EXPIRY_TIME)
  end

  def prune_recomlist_in_datastore(user_id,prunelist)
    return if prunelist.blank?
    key  = get_recomlist_tag_for_user(user_id)
    recom_list = get_recomlist_from_datastore(key)
    indices_of_common_ids = recom_list.each_index.select{|ind| prunelist.include?(recom_list[ind][0])}
    if !indices_of_common_ids.blank?
      remove_items_from_indices(key,indices_of_common_ids)
    end
  end

  def get_recomlist_from_datastore(key,count=0)
    @redis.lrange(key,0,count-1).map{|x| get_val_from_json(x)}
  end

  def get_info_for_recom_list(user_id)
    key  = get_recomlist_tag_for_user(user_id)
    recom_list =  get_recomlist_from_datastore(key)
    puts JSON(recom_list)
    puts recom_list.count

  end

  def get_recomlist_tag_for_user(user_id)
    "#{APIConstants::SYSTEM_CONSTANTS::REDIS_KEY_PREFIX}recomlist:uid:#{user_id}"
  end

  def get_val_from_json(json_string)
    JSON.parse(json_string)
  end

  def get_json_from_val(val)
    JSON(val)
  end

  def remove_items_from_indices(key,index_array)
    #puts index_array
    values = index_array.map{|index| @redis.lindex(key,index)}
    values.each{|val| @redis.lrem(key,0,val)}
  end

end