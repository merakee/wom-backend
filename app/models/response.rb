class Response < ActiveRecord::Base
  belongs_to :user
  belongs_to :content
  validates :user_id, :content_id, presence: true

  before_save :update_content_stat

  private
  def update_content_stat
    if (content = Content.where(:id => self.content_id).first)
      if self.response.nil?
        content.increment!(:no_response)
      elsif self.response
        content.increment!(:spread_response)
      else
        content.increment!(:kill_response)
      end
    end
  end
end
