class ContentSpreadingManager
  def self.get_spreadlist_for_user(user_id,count,blacklist)
    # RUN SQL
    # SELECT content_id, spread_index  FROM contents WHERE content_id NOT IN (blacklist, user_response_table) ORDER BY spread_index DESC LIMIT count
       contents =  if blacklist.blank?
        Content.find_by_sql([\
          "SELECT * FROM contents WHERE id NOT IN (SELECT content_id FROM user_responses WHERE user_id = :user_id) ORDER BY spread_index DESC LIMIT :limit  ",\
          {limit: APIConstants::CONTENT_SELECTION::CONTENT_COUNT_PER_REQUEST, \
         user_id: user_id}])
        else
         Content.find_by_sql([\
           "SELECT * FROM contents WHERE (id NOT IN (SELECT content_id FROM user_responses WHERE user_id = :user_id)) AND (id NOT IN (:blacklist)) ORDER BY spread_index DESC LIMIT :limit  ",\
          {limit: APIConstants::CONTENT_SELECTION::CONTENT_COUNT_PER_REQUEST, \
          blacklist: blacklist,\
         user_id: user_id}])
        end
        
    # return hash or array
    contents 
  end

end