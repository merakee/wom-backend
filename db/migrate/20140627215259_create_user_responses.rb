class CreateUserResponses < ActiveRecord::Migration
  def change
    create_table :user_responses do |t|
      t.belongs_to :user , :limit => 8 
      t.belongs_to :content , :limit => 8
      t.boolean :response, null: false

      t.timestamps
    end
    
    change_column :user_responses, :id, :integer, :limit => 8
        
  end
end
