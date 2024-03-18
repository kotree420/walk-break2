class AddEncordedPathToWalkingRoutes < ActiveRecord::Migration[7.0]
  def change
    add_column :walking_routes, :encorded_path, :string
  end
end
