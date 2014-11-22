class AppUtilManager
  
  # user response methods
  def self.create_random_response(total_count=5,batch_size=100,alpha=0.7)
    csm = ContentSelectionManager.new
    total_users = User.count
    user=nil

    (1..total_count).each {  |count|
      user = User.offset(rand(total_users)).first if ((count%batch_size == 1) || user.blank? )
      csm.get_contents_for_user(user.id).each{ |content|
      UserResponse.new(user_id: user.id, content_id: content.id, response: gen_response(alpha)).save 
     }
   }
    
  end
  
  def self.gen_response(alpha=0.7)
    rand(10000) < (alpha*10000)
  end
  
  
  # Mock for recommendation Engine
  def self.recommend_content(count=20)
    # pick random content
    Content.limit(count).offset(Content.count-count).pluck(:id).map{|x| [x,gen_recommendation_val]}
  end
  
  def self.gen_recommendation_val
    (rand(100)-25.0)/10.0
  end

end