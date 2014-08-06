class AddForeignKeyForUsersAndContentsToUserResponses < ActiveRecord::Migration
  def self.up
    add_foreign_key :user_responses , :users, :dependent => :delete
    add_foreign_key :user_responses , :contents, :dependent => :delete
  end
  
    def self.down
    remove_foreign_key :user_respones , :users
    remove_foreign_key :user_responsses , :contents
  end
  
end
