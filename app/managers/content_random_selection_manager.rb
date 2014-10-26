class ContentRandomSelectionManager
  def self.get_random_contents(user_id,count,blacklist)
    Content.where.not(id: blacklist).limit(count).pluck(:id).map{|x| [x,0.0]}
  end
end