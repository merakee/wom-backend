class AddAuthUseridToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :userid
    end

    add_index  :users, :userid, :unique => true
  end

  def self.down
    remove_column :users, :userid
  end
end
