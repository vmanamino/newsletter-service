class Subscriber < ActiveRecord::Base
    validates :email, presence: true
    has_many :interests
    has_many :categories, through: :interests
    
    def interests
        Interest.where(subscriber_id: id)
    end
    
    def categories
        Category.where(id: interests.pluck(:category_id))
    end
end
