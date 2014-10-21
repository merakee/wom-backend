class ContentStatManager
  def self.update_with_response(response)
    if (content = Content.where(:id => response.content_id).first)
      if response.response.nil?
        #content.increment!(:no_response_count)
        elsif response.response
          #content.increment!(:spread_count)
          Content.update_counters content.id, :spread_count => 1, :total_spread => 1
        else
        #content.increment!(:kill_count)
          Content.update_counters content.id, :kill_count => 1, :total_spread => 1
        end
      # update stat
      update_stat(content)
    end

  end

  def self.update_with_count(content_id,spread_count,kill_count)

  end

  def self.update_all
    puts "Updating all content stats...#{Time.now}"
  end

  def self.update_stat(content)
    stat = get_stat(content.spread_count, content.kill_count)
    content.update(freshness_factor: stat[:freshness_factor], spread_efficiency:stat[:spread_efficiency], spread_index: stat[:spread_index])
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
    #return 1.0 if total_count <= APIConstants::CONTENT_SELECTION::SPREAD_EFFICIENCY_THRESHOLD
    weighting_fac = cal_weighting_fac(total_count)
    combination_fac = -20*(weighting_fac*(freshness_factor-0.5) + (1-weighting_fac)*(spread_efficiency -0.5))
    1/(1+2**(combination_fac))
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