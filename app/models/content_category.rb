class ContentCategory < ActiveRecord::Base
      has_many :content, dependent: :destroy
       validates :category, presence: true, :inclusion => {:in => %w[News Secret Rumor LocalInfo Other]}

end
