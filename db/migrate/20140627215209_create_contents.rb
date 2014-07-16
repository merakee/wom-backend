class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.belongs_to :user
      t.belongs_to :content_category
      t.text :text
      t.string :photo_token
      t.integer :total_spread
      t.integer :spread_count
      t.integer :kill_count
      t.integer :no_response_count
            
      t.timestamps
    end
  end
end
