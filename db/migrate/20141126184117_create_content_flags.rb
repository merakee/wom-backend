class CreateContentFlags < ActiveRecord::Migration
  def change
    create_table :content_flags do |t|
      t.belongs_to :user , :limit => 8 
      t.belongs_to :content , :limit => 8
      t.datetime "created_at"
    end        
  end
end
