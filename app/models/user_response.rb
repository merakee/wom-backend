class UserResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :content
  validates :user, :content,  presence: true
  validates :response, inclusion: { in: [true, false] }
  #validates :response, allow_nil: true
  validates :user_id, uniqueness: { scope: [:content_id],
    message: "User already responsed to this content. User cannot respond to the same content more than once." }

  # update content stats
  after_save :update_content_stat

  private
  def update_content_stat
    ContentStatManager.update_with_response(self)
  end

end
