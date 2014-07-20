class UserResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :content
  validates :user, :content,  presence: true
  validates :response, inclusion: { in: [true, false] }
  #validates :response, allow_nil: true 
  validates :response, uniqueness: { scope: [:user_id, :content_id],
    message: "Cannot have more than one response per user per content" }

  before_save :update_content_stat

  private
  def update_content_stat
    if (content = Content.where(:id => self.content_id).first)
      if self.response.nil?
        content.increment!(:no_response_count)
      elsif self.response
        content.increment!(:spread_count)
      else
        content.increment!(:kill_count)
      end
    end
  end
end
