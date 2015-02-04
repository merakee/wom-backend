class CreateFavoriteContents < ActiveRecord::Migration
  def change
    create_table :favorite_contents do |t|
      t.belongs_to :user , :limit => 8
      t.belongs_to :content , :limit => 8
      t.column :created_at, :datetime
    end

    change_column :favorite_contents, :id, :integer, :limit => 8
    add_index :favorite_contents, :user_id
    add_index :favorite_contents, :content_id
  end
end
