class AddNewFieldsAndModifyUsers < ActiveRecord::Migration
  def change
    rename_column :users, :userid, :nickname
    change_column_null :users, :nickname, false
    change_column_default :users, :nickname, "Anonymous"

    add_column :users, :avatar, :string, default: "avatar.jpg", null: false
    add_column :users, :bio, :text, default: " ", null: false
    add_column :users, :social_tags, :string, array: true, default: []
    add_column :users, :hometown, :string, default: " ", null: false
  end
end
