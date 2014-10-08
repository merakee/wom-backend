class Content < ActiveRecord::Base  
  #belongs_to :content_category
  belongs_to :user
  has_many  :user_response, dependent: :destroy
  validates :user, presence: true
  #validates :content_category, presence: true
  validates :text, presence: true, length: { minimum: APIConstants::CONTENT::MIN_TEXT_LENGTH,
    maximum: APIConstants::CONTENT::MAX_TEXT_LENGTH}
  validates :text, uniqueness: { scope: [:user_id, :content_category_id],
    message: "User already has this content for the same category" }
    
    # carried wave - uploader 
    mount_uploader :photo_token, ContentPhotoUploader
   
   # add user response table 
   after_save :add_user_response

  private
  def add_user_response
    UserResponse.new(:user_id => self.user_id, :content_id => self.id, response: true).save
  end
  
    
end
