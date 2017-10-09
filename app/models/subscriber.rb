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
            lineage = c.ancestors.size
            puts "lineage #{lineage}"
            # listings exist for given category
            # creates a separate notification for each book that is cross listed
            # example is subscriber codes ab ef book3 ab ef, book 3 will appear twice
            # in separate notifications
            if Listing.find_by category_id: c.id
                # book_ids = Listing.where(category_id: c.id).map(&:book_id)
                book_ids = c.listings.map(&:book_id)
                book_ids.uniq!
                puts "book ids #{book_ids}"
                puts "code #{c.code}"
                puts " code id #{c.id}"
                book_ids.each do |book_id|
                    bn = BookNotification.new()
                    book = Book.find(book_id)
                    puts "book #{book.title}"
                    bn.book = book.title
                    # cat_ids = Listing.where(book_id: book_id).map(&:category_id)
                    # cat_ids.uniq!
                    cat_paths = []
                    # cat_ids.each do |cat_id|
                    path = []
                    cat = Category.find(c.id)
                    path.push(cat.title)
                    cat_paths.push(path)
                    # end
                    bn.categoryPaths = cat_paths
                    bn.newsletter = n
                    bn.save
                    bn_objs.push(BookNotificationSerializer.new(bn).to_json)
                end
                if c.descendants.size != 0
                    c.descendants.map(&:id).each do |cat_id|
                      puts "dec cat id #{cat_id}"
                      if Listing.find_by category_id: cat_id
                            book_ids = Listing.where(category_id: cat_id).map(&:book_id)
                            book_ids.uniq!
                            puts "book ids #{book_ids}"
                            puts "code #{c.code}"
                            puts " code id #{c.id}"
                            book_ids.each do |book_id|
                                bn = BookNotification.new()
                                book = Book.find(book_id)
                                puts "book #{book.title}"
                                bn.book = book.title
                                cat_ids = Listing.where(book_id: book_id).map(&:category_id)
                                cat_ids.uniq!
                                cat_paths = []
                                cat_ids.each do |cat_id|
                                    path = []
                                    cat = Category.find(cat_id)
                                    ancestors = cat.ancestors
                                        if ancestors.length != 0 or ancestors.length != 1
                                            subscriber_interests = ancestors.drop(lineage)
                                            subscriber_interests.map(&:title).each do |cat|
                                                path.push(cat) 
                                            end
                                        end
                                    path.push(cat.title)
                                    cat_paths.push(path)
                                end
                                bn.categoryPaths = cat_paths
                                bn.newsletter = n
                                bn.save
                                bn_objs.push(BookNotificationSerializer.new(bn).to_json)
                            end
                        end
                    end
                end
            end
            # if c.descendants.size != 0
            #     puts "my desc #{c.descendants.size}"
            #     descendant_objs = c.descendants
            #     puts "my descc objs #{descendant_objs.map(&:title)}"
            #     c.descendants.each do |cat|
            #         puts "cat id #{cat.id}"
            #         if Listing.find_by category_id: cat.id
            #             listing = Listing.find_by category_id: cat.id
            #             puts "listing for desc #{listing.category_id}"
            #             if Book.find_by id: listing.book_id
            #                 book = Book.find_by id: listing.book_id
            #                 puts "book #{book.title}"
            #                 book_cat_ids = Listing.where(book_id: book).map(&:category_id)
            #                 puts "book categories #{book_cat_ids}"
            #                 bn = BookNotification.new()
            #                 cat_paths = []
            #                 # book_cat_ids.each do |cat_id|
            #                 #     ancestors = cat.ancestors.map(&:title)
            #                 #     cat_path = ancestors.drop(lineage)
            #                 #     cat_paths.push(cat_path)
            #                 # end
            #                 # puts "cat paths #{cat_paths}"
            #             end
            #         end
            #     end
            # end
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
        n.notifications = bn_objs
        n.save
        end
    end
end
