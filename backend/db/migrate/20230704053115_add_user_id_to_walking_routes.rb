class AddUserIdToWalkingRoutes < ActiveRecord::Migration[7.0]
  def change
    add_reference :walking_routes, :user, null: false, foreign_key: true
  end
end
