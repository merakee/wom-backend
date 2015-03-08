module APIConstants
  # API USER TYPE
  module API_USER_TYPE
    ANONYMOUS =1
    WOM =2
    FACEBOOK =3
    TWITTER =4
    GOOGLE_PLUS =5
    OTHERS =6
  end

  # USER RELATED
  module USER
    NICKNAME_LENGTH_MIN = 2
    NICKNAME_LENGTH_MAX = 17
    BIO_LENGTH_MIN = 1
    BIO_LENGTH_MAX = 100
    HOMETOWN_LENGTH_MIN = 1
    HOMETOWN_LENGTH_MAX = 40
  end
  
  # CONTENT RELARED
  module CONTENT
    MIN_TEXT_LENGTH =1
    MAX_TEXT_LENGTH =250
  end

  # SYSTEM WIDE RELATED
    module SYSTEM_CONSTANTS    
      REDIS_KEY_PREFIX = 'wom:'
    end

  # CONTENT SELECTION
  module CONTENT_SELECTION
    CONTENT_COUNT_PER_REQUEST = 20 
    
    # spreader 
    FRESSNESS_THRESHOLD_MIN = 25 
    FRESSNESS_THRESHOLD_MAX = 8*FRESSNESS_THRESHOLD_MIN
    SPREAD_EFFICIENCY_THRESHOLD = 25
    SPREAD_EFFICIENCY_THRESHOLD_MAX = 4*SPREAD_EFFICIENCY_THRESHOLD

    # recommender
    RECOMMENDER_SPREAD_VAL = 5.0
    RECOMMENDER_KILL_VAL = -1.0
    RECOMMENDER_NORMALIZE_SCALE = 1.0/(RECOMMENDER_SPREAD_VAL - RECOMMENDER_KILL_VAL)    
    RECOMMENDER_TIME_OUT = 1.0 # in sec 
    RECOMMENDER_RELATIVE_WEIGHT = 1.0 # 1.0 is equal importance to spreadind, > 1.0 is higher, and < 1.0 is lower 
    RECOMMENDER_RECOMMENDATION_SIZE  = 200
    RECOMMENDER_RECOMMENDATION_EXPIRY_TIME  = 600
    
    
    # black list
    BLACKLIST_SIZE = 200
    BLACKLIST_EXPIRY_TIME = 600
    
    # Recent list
    RECENT_BLOCKSIZE_DEFAULT = 100
    RECENT_BLOCKSIZE_MAX = 1000
  end
  
   # CONTENT SELECTION
  module COMMENT
    MIN_TEXT_LENGTH =1
    MAX_TEXT_LENGTH =400
    COMMENT_COUNT_PER_REQUEST = 20 
    COMMENT_MODE_POPULAR = "popular"
    COMMENT_MODE_RECENT = "recent"
  end
  
  module HISTORY
    ITEM_COUNT_PER_REQUEST = 20 
  end
  
  module FAVORITES
    TOTAL_MAX_FAVORITES = 100
  end
  

end