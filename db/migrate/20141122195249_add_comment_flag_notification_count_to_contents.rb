class AddCommentFlagNotificationCountToContents < ActiveRecord::Migration
  def change
    add_column :contents, :comment_count, :integer, default: 0, null: false
    add_column :contents, :flag_count, :integer, default: 0, null: false
    add_column :contents, :new_comment_count, :integer, default: 0, null: false
  end
end
