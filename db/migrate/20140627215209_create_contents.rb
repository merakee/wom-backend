class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.belongs_to :user
      t.belongs_to :content_category
      t.text :text
      t.string :photo_token

      t.timestamps
    end
  end
end
