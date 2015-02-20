class AddNewFieldsAndModifyUsers < ActiveRecord::Migration
  def change
    remove_column :users, :userid

    add_column :users, :nickname, :string, default: "Anonymous", null: false
    add_column :users, :avatar, :string, default: "avatar.jpg", null: false
    add_column :users, :bio, :text, default: " ", null: false
    add_column :users, :social_tags, :string, array: true, default: [], null: false
    add_column :users, :hometown, :string, default: " ", null: false
  end
end
