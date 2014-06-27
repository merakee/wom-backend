class CreateContentCategories < ActiveRecord::Migration
  def change
    create_table :content_categories do |t|
      t.string :category

      t.timestamps
    end
  end
end
