class CreateUserResponses < ActiveRecord::Migration
  def change
    create_table :user_responses do |t|
      t.belongs_to :user
      t.belongs_to :content
      t.boolean :response

      t.timestamps
    end
  end
end
