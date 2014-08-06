class AddForeignKeyForUsersToCotents < ActiveRecord::Migration
  def self.up 
    add_foreign_key :contents , :users, :dependent => :delete 
  end
  
  def self.down
    remove_foreign_key :contents , :users 
  end

end
