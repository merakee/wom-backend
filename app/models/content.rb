class Content < ActiveRecord::Base
  belongs_to :content_category
  belongs_to :user
  has_many  :user_response, dependent: :destroy
  validates :user, :content_category, presence: true
  validates :text, presence: true, length: { minimum: APIConstants::CONTENT::MIN_TEXT_LENGTH,
    maximum: APIConstants::CONTENT::MAX_TEXT_LENGTH}
end
