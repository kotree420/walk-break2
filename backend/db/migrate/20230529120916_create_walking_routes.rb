class CreateWalkingRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :walking_routes do |t|
      t.string :name, null: false
      t.text :comment, null: false
      t.float :distance, null: false
      t.integer :duration, null: false
      t.string :start_address, null: false
      t.string :end_address, null: false

      t.timestamps
    end
  end
end
