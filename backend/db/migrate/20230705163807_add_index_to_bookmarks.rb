class AddIndexToBookmarks < ActiveRecord::Migration[7.0]
  def change
    add_index :bookmarks, [:user_id, :walking_route_id], unique: true
  end
end
