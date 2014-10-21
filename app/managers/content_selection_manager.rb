class ContentSelectionManager

  attr_reader :redis
  def initialize
    @redis = DataStore.redis
  end

  # selection manager
  def get_contents_for_user(user_id)
    # select list of content for user with :id
    select_contents_for_user(user_id)
  end

  # method to select content by combining all sources
  def select_contents_for_user(user_id)
    # get black list
    blacklist = get_blacklist_for_user(user_id)
    
    # spreading manager
    contents_spread = get_content_from_spreading_manager_for_user(user_id,blacklist)
    # recommendation manager
    contents_recom = get_content_from_recommendation_manager_for_user(user_id,blacklist)
    
    # sort and select
    contents = sort_and_select(contents_spread,contents_recom)
    
    # check to see empty array and may add random content
    # random source 
    # if contents.blank?
      # contents = get_random_contents(user_id,blacklist)
    # end


    # update black list
    update_blacklist_for_user(user_id,contents.map{|content| content.id}) unless contents.blank? 
    
    # return
    contents 
  end

def sort_and_select(spread_list,recom_list)
  spread_list
end
  # method for selecting random content
  def get_random_contents(user_id,blacklist)
    offset = [rand(Content.count)-APIConstants::CONTENT_SELECTION::CONTENT_COUNT_PER_REQUEST, 0].max
    #Content.limit(APIConstants::CONTENT_SELECTION::CONTENT_COUNT_PER_REQUEST).offset(offset)
    if blacklist.blank?
      Content.find_by_sql(["SELECT * FROM contents  LIMIT :limit OFFSET :offset ",\
        {limit: APIConstants::CONTENT_SELECTION::CONTENT_COUNT_PER_REQUEST, \
        offset: offset}])
      else
       Content.find_by_sql(["SELECT * FROM contents WHERE id NOT IN (:blacklist)  LIMIT :limit OFFSET :offset ",\
        {limit: APIConstants::CONTENT_SELECTION::CONTENT_COUNT_PER_REQUEST, \
        offset: offset,\
        blacklist: blacklist}])

      end
  end

  # methods for content spreading manager
  def get_content_from_spreading_manager_for_user(user_id,blacklist)
    ContentSpreadingManager.get_spreadlist_for_user(user_id,APIConstants::CONTENT_SELECTION::CONTENT_COUNT_PER_REQUEST,get_blacklist_for_user(user_id))
  end
  # methods for content recommendation manager
  def get_content_from_recommendation_manager_for_user(user_id,blacklist)
    [] #ContentSpreadingManager.get_spreadlist_for_user(user_id,APIConstants::CONTENT_SELECTION::CONTENT_COUNT_PER_REQUEST,get_blacklist_for_user(user_id))
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

  def get_blacklist_for_user(user_id)
    key = get_blacklist_key_for_user(user_id)
    # get list
    @redis.lrange(key,0,-1)
  end

  def get_blacklist_key_for_user(user_id)
    "blacklist:uid:#{user_id}"
  end

end