class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :user , :limit => 8
      t.belongs_to :content , :limit => 8

      t.text :text, default: "", null: false
      t.integer :like_count, default: 0, null: false
      t.integer :new_like_count, default: 0, null: false

      t.timestamps
    end
    
    change_column :comments, :id, :integer, :limit => 8
    
    add_index :comments, :user_id
    add_index :comments, :content_id
    
    add_foreign_key :comments , :users, :dependent => :delete
    add_foreign_key :comments , :contents, :dependent => :delete
    
  end
end
