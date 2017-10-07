class Listing < ActiveRecord::Base
  belongs_to :book
  belongs_to :category
  
  # def self.books
  #   Book.where(id: pluck(:book_id))
  # end
  
  # def self.categories
  #   Category.where(id: pluck(:category_id))
  # end
  
end
