class CreateCommentResponse < ActiveRecord::Migration
  def change
    create_table :comment_responses do |t|
      t.belongs_to :user , :limit => 8
      t.belongs_to :comment , :limit => 8

      t.boolean :response, null: false, default: false 

      t.datetime "created_at"
    end
    
    change_column :comment_responses, :id, :integer, :limit => 8
    
    add_index :comment_responses, :user_id
    add_index :comment_responses, :comment_id
    
    add_foreign_key :comment_responses , :users, :dependent => :delete
    add_foreign_key :comment_responses , :comments, :dependent => :delete
 
    end
   
end