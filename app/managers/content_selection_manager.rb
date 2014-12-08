class ContentSelectionManager
  attr_reader :redis
  
  def initialize
    @content_spreading_manager = ContentSpreadingManager.new
    @content_recommendation_manager = ContentRecommendationManager.new
    @redis = DataStore.redis
  end

  # selection manager
  def get_contents_for_user(user_id,count=APIConstants::CONTENT_SELECTION::CONTENT_COUNT_PER_REQUEST)
    # select list of content for user with :id
    select_contents_for_user(user_id,count)
  end

  # method to select content by combining all sources

  def select_contents_for_user(user_id,count)
    # get black list
    # redis list: last send list
    blacklist = get_blacklist_for_user(user_id)
    # responded list
    blacklist += get_responded_list(user_id)

    # spreading manager
    content_ids_spread = get_content_from_spreading_manager_for_user(user_id,count,blacklist)
    # recommendation manager
    # note: blacklist for recommendation can be restricted to only get_responded_list
    # assuming recommendation engine will update before the list if exhausted
    # attaching the already responded list may be over kill and too much excess computation for heavy users
    # need to carefully think about all the corner cases
    content_ids_recom = get_content_from_recommendation_manager_for_user(user_id,count,blacklist)

    # sort and select
    content_ids = sort_and_select(content_ids_spread,content_ids_recom,count)

    # remove selected ids from recom list
    remove_content_ids_from_recommendation_list(user_id,content_ids)
    #get_info_for_recommendation_list(user_id)

    # check to see empty array and may add random content
    # random source
    # if contents.blank?
    # content_ids_random = get_random_contents_for_user(user_id,count,blacklist)
    # end

    # update black list
    update_blacklist_for_user(user_id,content_ids) unless content_ids.blank?

    # return
    Content.where(id: content_ids)
  end

  def sort_and_select(spread_ids_list,recom_ids_list,count)
    # return the ids from spread list if recom is empty
    return spread_ids_list.map{|x| x[0]} if recom_ids_list.blank?
    return recom_ids_list.map{|x| x[0]} if spread_ids_list.blank?

    # spread and recommendation is treated equally
    recom_ids_list = recom_ids_list.map{|x| [x[0], x[1]*APIConstants::CONTENT_SELECTION::RECOMMENDER_RELATIVE_WEIGHT]}
    # merge and sort
    merged_and_sorted_list = (spread_ids_list + recom_ids_list).sort{|x,y| y[1] <=> x[1]}
    # pick only ids, delete duplication and truncate
    merged_and_sorted_list.map{|x| x[0]}.uniq[0...count]
  end

  # method for selecting random content
  def get_random_contents_for_user(user_id,count,blacklist)
    ContentRandomSelectionManager.get_random_contents(user_id,count,blacklist)
  end

  # methods for content spreading manager
  def get_content_from_spreading_manager_for_user(user_id,count,blacklist)
    @content_spreading_manager.get_spreadlist_for_user(user_id,count,blacklist)
  end

  # methods for content recommendation manager

  def get_content_from_recommendation_manager_for_user(user_id,count,blacklist)
    @content_recommendation_manager.get_recomlist_for_user(user_id,count,blacklist)
  end

  def remove_content_ids_from_recommendation_list(user_id,content_id_list)
    @content_recommendation_manager.prune_recomlist_in_datastore(user_id,content_id_list)
  end

  def get_info_for_recommendation_list(user_id)
    @content_recommendation_manager.get_info_for_recom_list(user_id)
  end

  # methods for black list

  def update_blacklist_for_user(user_id,list)
    return if list.blank?
    # get tag
    key = get_blacklist_key_for_user(user_id)
    # push list
    @redis.lpush(key, list)
    # Fixed size: set constraint
    @redis.ltrim(key,0,APIConstants::CONTENT_SELECTION::BLACKLIST_SIZE)
    # set ttl
    @redis.expire(key,APIConstants::CONTENT_SELECTION::BLACKLIST_EXPIRY_TIME)
  end

  def get_responded_list(user_id)
    UserResponse.where(user_id: user_id).pluck(:content_id)
  end

  def get_blacklist_for_user(user_id)
    key = get_blacklist_key_for_user(user_id)
    # get list
    @redis.lrange(key,0,-1)
  end

  def get_blacklist_key_for_user(user_id)
    "#{APIConstants::SYSTEM_CONSTANTS::REDIS_KEY_PREFIX}blacklist:uid:#{user_id}"
  end



# methods for selecting recent contents

  def get_contents_recent(params)
    # chek params and set default 
    set_default_params(params)
    Content.order(created_at: :desc).limit(params[:count]).offset(params[:offset])
  end
  
  def set_default_params(params)
    params[:count] = APIConstants::CONTENT_SELECTION::RECENT_BLOCKSIZE_DEFAULT unless params.has_key?(:count) && params[:count] && params[:count]>0
    params[:count] = APIConstants::CONTENT_SELECTION::RECENT_BLOCKSIZE_MAX if params[:count] > APIConstants::CONTENT_SELECTION::RECENT_BLOCKSIZE_MAX
    params[:offset] = 0 unless params.has_key?(:offset) && params[:offset] && params[:offset] >= 0
  end
  
end