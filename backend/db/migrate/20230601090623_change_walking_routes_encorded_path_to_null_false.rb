class ChangeWalkingRoutesEncordedPathToNullFalse < ActiveRecord::Migration[7.0]
  def change
    change_column :walking_routes, :encorded_path, :string, null: false
  end
end
