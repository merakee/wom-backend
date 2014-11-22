class ContentFlag < ActiveRecord::Base
  belongs_to :user
  belongs_to :content
  validates :user, :content,  presence: true
  validates :user_id, uniqueness: { scope: [:content_id],
    message: "User already flagged this content. User cannot flag the same content more than once." }

  # update content stats
  after_save :update_content_stat

  private
  def update_content_stat
    ContentStatManager.update_with_flag(self)
  end
  
end
