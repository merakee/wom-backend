class AppUtilManager
  
  def self.create_random_response(total_count=5,batch_size=100,alpha=0.7)
    csm = ContentSelectionManager.new
    total_users = User.count
    user=nil

    (1..total_count).each {  |count|
      puts count 
      user = User.offset(rand(total_users)).first if ((count%batch_size == 1) || user.blank? )
      csm.get_contents_for_user(user.id).each{ |content|
      UserResponse.new(user_id: user.id, content_id: content.id, response: gen_response(alpha)).save 
     }
   }
    
  end
  
  def self.gen_response(alpha=0.7)
    rand(10000) < (alpha*10000)
  end
end