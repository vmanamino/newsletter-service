class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :code, :parent_id
end
