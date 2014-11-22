class CommentStatManager
 def self.update_with_response(response)
    if response.response
      Comment.update_counters response.comment_id, :like_count => 1, :new_like_count => 1
    end
  end
  
  def self.update_all_stat
    Comment.find_each do |comment|
      update_count_and_stat(comment)
    end
  end

  def self.update_count_and_stat(comment)
    count = get_count_for_comment(comment.id)
    update_stat_for_count(comment,count[:like_count])
  end

  def self.update_stat_for_count(comment,like_count)
    comment.update(like_count: like_count)
  end

  def self.get_count_for_comment(comment_id)
    like_count = CommentResponse.where(comment_id: comment_id, response: true).count
    {like_count: like_count}
  end
    
  def self.check_all_stat
          total_errors=0;
    Comment.find_each do |comment|
      total_errors += check_count_and_stat(comment)
    end
   Rails.logger.info  "Total mismatch: #{total_errors}"
  end
  
  def self.check_count_and_stat(comment)
   count = get_count_for_comment(comment.id)    
   if(comment.like_count!=count[:like_count])
     #Rails.logger.info "Mismatch found: #{comment.id}...updating information"
     comment.update(like_count: count[:like_count])
     return 1
   end
   return 0 
  end

end
