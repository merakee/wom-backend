class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.belongs_to :user
      t.belongs_to :content_category
      t.text :text
      t.string :photo_token
      t.integer :spread_count
      t.integer :spread_response
      t.integer :kill_response
      t.integer :no_response
            
      t.timestamps
    end
  end
end
