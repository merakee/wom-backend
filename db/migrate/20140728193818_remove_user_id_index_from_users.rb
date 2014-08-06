class RemoveUserIdIndexFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :column=> :userid 
  end
 
end
