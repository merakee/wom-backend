class Content < ActiveRecord::Base
  belongs_to :content_category
  belongs_to :user 
  
  validates :text, length: { minimum: 2 }
end
