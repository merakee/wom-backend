class Content < ActiveRecord::Base
  belongs_to :content_category
  belongs_to :user 
  has_many  :user_response, dependent: :destroy
  validates :user, :content_category, presence: true
  validates :text, presence: true, length: { minimum: 2 }
end
