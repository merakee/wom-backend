class UserRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :content
  validates :user, :content,  presence: true
  validates :rating, presence: true
  validates :user_id, uniqueness: { scope: [:content_id],
    message: "User ratings exists for this content. Cannot have multiple user ratings." }

end
