class CreateUserRatings < ActiveRecord::Migration
  def change
    create_table :user_ratings do |t|
      t.belongs_to :user , :limit => 8
      t.belongs_to :content , :limit => 8
      t.float :rating, null: false, default: 0.0

      t.timestamps
    end

    change_column :user_ratings, :id, :integer, :limit => 8
    add_index :user_ratings, :user_id
    add_index :user_ratings, :content_id
    
  end

end

