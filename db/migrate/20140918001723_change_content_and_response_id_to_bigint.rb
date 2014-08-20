class ChangeContentAndResponseIdToBigint < ActiveRecord::Migration
  def change
    change_column :contents,       :id, :integer, :limit => 8
    change_column :user_responses, :id, :integer, :limit => 8
    change_column :user_responses, :content_id, :integer, :limit => 8
  end
end
