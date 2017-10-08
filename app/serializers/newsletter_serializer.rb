class NewsletterSerializer < ActiveModel::Serializer
  attributes :recipient, :notifications
end
