class Category < ActiveRecord::Base
    acts_as_tree order: "title"
    validates :code, :title, presence: true
    validates :code, uniqueness: true
    has_many :listings
    has_many :books, through: :listings
    
    def listings
        Listing.where(category_id: id)
    end
    
    def books
        Book.where(id: listings.pluck(:book_id))
    end
    
end
