class Subscriber < ActiveRecord::Base
    validates :email, presence: true
    serialize :categoryCodes, Array
    has_many :interests
    has_many :categories, through: :interests
    has_one :newsletter
    
    after_create :create_interests, :create_newsletter_with_notifications
    
    def interests
        Interest.where(subscriber_id: id)
    end
    
    def categories
        Category.where(id: interests.pluck(:category_id))
    end
    
    private
    
    def create_interests
        self.categoryCodes.each do |code|
            c = Category.find_by code: code
            Interest.create("subscriber"=>self, "category"=>c)
        end 
    end
    
    def create_newsletter_with_notifications
        n = Newsletter.create("subscriber"=> self)
        bn_objs = [] 
        self.categoryCodes.each do |code|
            c = Category.find_by code: code
            # puts "cat code #{c}"
            # puts "any descendants #{c.descendants}"
            lineage = c.ancestors.size
            puts "lineage #{lineage}"
            if lineage != 0
                puts " some work to do here #{lineage}"
        #     if c.descendants.length != 0
        #         # length = descendant_objs.length
        #         c.descendants.each do |cat|
        #             puts "cat id #{cat.id}"
        #             listing = Listing.find_by category_id: cat.id
        #             puts "the listing #{listing}"
        #             book = Book.find_by id: listing.book_id
        #             book_cat_ids = Listing.where(book_id: book).map(&:category_id)
        #             bn = BookNotification.new()
        #             puts book
        #             cat_paths = []
        #             book_cat_ids.each do |cat_id|
        #                 ancestors = cat.ancestors.map(&:title)
        #                 cat_path = ancestors.drop(lineage)
        #                 cat_paths.push(cat_path)
        #             end
        #             bn.categoryPaths = cat_paths
        #             bn.newsletter = n
        #             bn.save
        #             bn_objs.push(BookNotificationSerializer.new(bn).to_json)
        #         end
        #     end
        # end
        # n.notifications = bn_objs
        # n.save
        end
    end
end
