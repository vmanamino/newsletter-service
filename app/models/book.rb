class Book < ActiveRecord::Base
    validates :title, presence: true
    serialize :categoryCodes
    has_many :listings
    has_many :categories, through: :listings
    
    after_create :create_listings
    
    def listings
        Listing.where(book_id: id)
    end
    
    def categories
        Category.where(id: listings.pluck(:category_id))
    end
    
    def create_listings
        self.categoryCodes.each do |code|
            c = Category.find_by code: code
            Listing.create("book"=>self, "category"=>c) 
        end
    end
    
end
