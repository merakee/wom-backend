class AddUserIdAndContentIdIndexToUserResponses < ActiveRecord::Migration
  def change
    add_index :user_responses, :user_id
    add_index :user_responses, :content_id
  end
end
