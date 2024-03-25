class IndexRouteUserResource < BaseResource
  root_key :walking_route

  attributes :id, :name

  one :user, resource: UserResource
end
