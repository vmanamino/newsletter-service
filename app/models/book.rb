class Book < ActiveRecord::Base
    validates :title, presence: true
    has_many :listings
    has_many :categories, through: :listings
    
    def listings
        Listing.where(book_id: id)
    end
    
    def categories
        Category.where(id: listings.pluck(:category_id))
    end
end
