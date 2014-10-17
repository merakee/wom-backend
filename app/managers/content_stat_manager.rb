class ContentStatManager
  
  def self.update_with_response(response)
    if (content = Content.where(:id => response.content_id).first)
      if response.response.nil?
        content.increment!(:no_response_count)
      elsif response.response
        content.increment!(:spread_count)
      else
        content.increment!(:kill_count)
      end
    end

  end

  def self.update_with_count(content_id,spread_count,kill_count)

  end

  def self.update_all
    puts "Updating all content stats...#{Time.now}"
  end

end