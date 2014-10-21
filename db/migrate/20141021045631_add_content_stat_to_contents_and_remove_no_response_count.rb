class AddContentStatToContentsAndRemoveNoResponseCount < ActiveRecord::Migration
  def change
    remove_column :contents, :no_response_count, :integer, default: 0, null: false
    add_column :contents, :freshness_factor, :float, default: 1.0, null: false
    add_column :contents, :spread_efficiency, :float, default: 1.0, null: false
    add_column :contents, :spread_index, :float, default: 1.0, null: false
    add_index :contents, :spread_index
  end
end
