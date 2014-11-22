class Comment < ActiveRecord::Base 
  
  belongs_to :content
  belongs_to :user
  has_many  :comment_response, dependent: :destroy
  validates :user, :content, presence: true
  validates :text, presence: true, length: { minimum: APIConstants::COMMENT::MIN_TEXT_LENGTH,
    maximum: APIConstants::COMMENT::MAX_TEXT_LENGTH}
  
  # change validation of presence of text with condition on photo_tag 
  validates :text, uniqueness: { scope: [:user_id, :content_id], message: "User already has this comment for the same content" }
  
  # update content stats
  after_save :update_content_stat

  private
  def update_content_stat
    ContentStatManager.update_with_comment(self)
  end
  
end
