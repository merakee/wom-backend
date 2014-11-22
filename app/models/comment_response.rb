class CommentResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment
  validates :user, :comment,  presence: true
  validates :response, inclusion: { in: [true, false] }
  #validates :response, allow_nil: true
  validates :user_id, uniqueness: { scope: [:comment_id],
    message: "User already liked this comment. User cannot like same comment more than once." }

  # update content stats
  after_save :update_comment_stat

  private
  def update_comment_stat
    CommentStatManager.update_with_response(self)
  end
  
end