class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :categoryCodes
end