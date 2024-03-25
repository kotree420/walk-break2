class UserResource < BaseResource
  root_key :user

  attributes :id, :name, :profile_image, :body_weight
end
