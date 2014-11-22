class ContentStatManager
 def self.update_with_response(response)
    if (content = Content.where(:id => response.content_id).first)
      if response.response == true
        #content.increment!(:spread_count)
        Content.update_counters content.id, :spread_count => 1, :total_spread => 1
      elsif response.response == false
        #content.increment!(:kill_count)
        Content.update_counters content.id, :kill_count => 1, :total_spread => 1
      end
      # update stat only if response is not nil
      update_stat(content) if response.response != nil
    end
  end

 def self.update_with_comment(comment)
    if comment
      Content.update_counters comment.content_id, :comment_count => 1, :new_comment_count => 1
    end
  end
  
   def self.update_with_flag(flag)
    if flag
      Content.update_counters flag.content_id, :flag_count => 1
    end
  end
  
  def self.update_stat(content)
    stat = get_stat(content.spread_count, content.kill_count)
    content.update(freshness_factor: stat[:freshness_factor], spread_efficiency:stat[:spread_efficiency], spread_index: stat[:spread_index])
  end
  
  def self.update_all_stat
    Content.find_each do |content|
      update_count_and_stat(content)
    end
  end

 def self.update_count_and_stat(content)
    count = get_count_for_content(content.id)
    update_stat_for_count(content,count[:spread_count],content[:kill_count])
  end

  def self.update_stat_for_count(content,spread_count,kill_count)
    stat = get_stat(spread_count, kill_count)
    content.update(spread_count: spread_count , kill_count: kill_count,total_spread: spread_count+kill_count, freshness_factor: stat[:freshness_factor], spread_efficiency:stat[:spread_efficiency], spread_index: stat[:spread_index])
  end

  def self.get_count_for_content(content_id)
    spread_count = UserResponse.where(content_id: content_id, response: true).count
    kill_count = UserResponse.where(content_id: content_id, response: false).count
    {spread_count: spread_count,kill_count: kill_count}
  end
    
  def self.check_all_stat
          total_errors=0;
    Content.find_each do |content|
      total_errors += check_count_and_stat(content)
    end
   Rails.logger.info "Total mismatch: #{total_errors}"
  end
  
  def self.check_count_and_stat(content)
   count = get_count_for_content(content.id)    
   stat = get_stat(count[:spread_count],content[:kill_count])
   if(content.spread_count!=count[:spread_count]||
     content.kill_count!=count[:kill_count]||
     content.total_spread!=count[:spread_count]+count[:kill_count]||
     content.spread_efficiency!=stat[:spread_efficiency]||
     content.freshness_factor!=stat[:freshness_factor]||
     content.spread_index!=stat[:spread_index])
     #Rails.logger.info "Mismatch found: #{content.id}...updating information"
     content.update(spread_count: count[:spread_count] , kill_count: count[:kill_count],total_spread: count[:spread_count]+count[:kill_count], freshness_factor: stat[:freshness_factor], spread_efficiency:stat[:spread_efficiency], spread_index: stat[:spread_index])
     return 1
   end
   return 0 
  end



 # stat calculation methods
  def self.get_stat(spread_count,kill_count)
    total_count = (spread_count+kill_count).to_f
    stat = {}
    stat[:freshness_factor]= get_freshness_factor(spread_count,kill_count,total_count)
    stat[:spread_efficiency]= get_spread_efficiency(spread_count,kill_count,total_count)
    stat[:spread_index]=get_spread_index(stat[:freshness_factor],stat[:spread_efficiency],total_count)
    stat
  end

  def self.get_freshness_factor(spread_count,kill_count,total_count)
    #return 1.0 if total_count <= APIConstants::CONTENT_SELECTION::FRESSNESS_THRESHOLD
    #APIConstants::CONTENT_SELECTION::FRESSNESS_THRESHOLD/total_count
    if  total_count <= APIConstants::CONTENT_SELECTION::FRESSNESS_THRESHOLD_MIN
    1.0
    elsif total_count <= APIConstants::CONTENT_SELECTION::FRESSNESS_THRESHOLD_MAX
      APIConstants::CONTENT_SELECTION::FRESSNESS_THRESHOLD_MIN / total_count
    else
    0.0
    end
  end

  def self.get_spread_efficiency(spread_count,kill_count,total_count)
    return 1.0 if total_count <= 0.0
    spread_count/total_count
  end

  def self.get_spread_index(freshness_factor,spread_efficiency,total_count)
    [freshness_factor,spread_efficiency].max 
    #return 1.0 if total_count <= APIConstants::CONTENT_SELECTION::SPREAD_EFFICIENCY_THRESHOLD
    # weighting_fac = cal_weighting_fac(total_count)
    # combination_fac = -20*(weighting_fac*(freshness_factor-0.5) + (1-weighting_fac)*(spread_efficiency -0.5))
    # 1/(1+2**(combination_fac))
  end

  def self.cal_weighting_fac(total_count)
    if total_count <= APIConstants::CONTENT_SELECTION::SPREAD_EFFICIENCY_THRESHOLD
    1.0
    elsif total_count <= APIConstants::CONTENT_SELECTION::SPREAD_EFFICIENCY_THRESHOLD_MAX
      2**(10*(-total_count/APIConstants::CONTENT_SELECTION::SPREAD_EFFICIENCY_THRESHOLD+1.0))
    else
    0.0
    end

  end

end