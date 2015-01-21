class Content < ActiveRecord::Base
  belongs_to :content_category
  belongs_to :user
  has_many  :user_response, dependent: :destroy
  has_many :user_rating, dependent: :destroy
  validates :user, :content_category, presence: true

  # change validation of presence of text with condition on photo_tag
  validates :text, presence: true, length: { minimum: APIConstants::CONTENT::MIN_TEXT_LENGTH,
    maximum: APIConstants::CONTENT::MAX_TEXT_LENGTH }, if: "photo_token.blank?"
  validates :text, uniqueness: { scope: [:user_id, :content_category_id],
    message: "User already has this content for the same category" }, if: "photo_token.blank?"

  # carried wave - uploader
  mount_uploader :photo_token, ContentPhotoUploader

  # add user response table
  after_save :add_user_response

  private
  def add_user_response
    UserResponse.new(:user_id => self.user_id, :content_id => self.id, response: true).save
  end

end
