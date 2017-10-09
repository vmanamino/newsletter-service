class Category < ActiveRecord::Base
    acts_as_tree order: "title"
    validates :code, :title, presence: true
    validates :code, uniqueness: true
    has_many :listings
    has_many :books, through: :listings
    
    after_create :set_parent
    
    def listings
        Listing.where(category_id: id)
    end
    
    def books
        Book.where(id: listings.pluck(:book_id))
    end
    
    private
    
    def set_parent
        parent = Category.find_by code:self.superCategoryCode
        self.parent_id = parent.id
        self.save
    end
    
end
