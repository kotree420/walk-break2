class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :walking_route

  validates :user_id, uniqueness: { scope: :walking_route_id }
end
