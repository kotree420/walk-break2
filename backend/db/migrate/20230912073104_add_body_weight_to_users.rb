class AddBodyWeightToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :body_weight, :integer
  end
end
