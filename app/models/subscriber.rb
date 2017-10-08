class Subscriber < ActiveRecord::Base
    validates :email, presence: true
    serialize :categoryCodes
    has_many :interests
    has_many :categories, through: :interests
    has_one :newsletter
    
    after_create :create_interests
    
    def interests
        Interest.where(subscriber_id: id)
    end
    
    def categories
        Category.where(id: interests.pluck(:category_id))
    end
    
    def create_interests
       self.categoryCodes.each do |code|
            c = Category.find_by code: code
            l = Interest.create("subscriber"=>self, "category"=>c) 
        end 
    end
end
