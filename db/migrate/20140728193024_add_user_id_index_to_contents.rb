class AddUserIdIndexToContents < ActiveRecord::Migration
  def change 
    add_index :contents, :user_id
  end

end
