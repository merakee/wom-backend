class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.belongs_to :user , :limit => 8
      t.belongs_to :content_category
      t.text :text, default: "", null: false
      t.string :photo_token, default: "", null: false
      t.integer :total_spread, default: 0, null: false
      t.integer :spread_count, default: 0, null: false
      t.integer :kill_count, default: 0, null: false
      t.integer :no_response_count, default: 0, null: false
            
      t.timestamps
    end
    
    change_column :contents, :id, :integer, :limit => 8
    
  end
end
