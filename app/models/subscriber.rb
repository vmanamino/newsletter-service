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
            # if listings exist for top level categories
            # creates a separate notification for each book that is cross listed
            # example is subscriber codes ab ef book3 with codes ab ef, book 3 will appear twice
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
                                cat_ids.each do |id|
                                    path = []
                                    cat = Category.find(id)
                                    ancestors = cat.ancestors
                                        if ancestors.length != 0 or ancestors.length != 1
                                            subscriber_interests = ancestors.drop(lineage)
                                            subscriber_interests.map(&:title).each do |cat_segment|
                                                path.push(cat_segment) 
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
            # for book belonging to descendants, no top level topics
            else # c.descendants.size != 0
                puts " category #{c.title}"
                puts " descendants #{c.descendants.map(&:title)}"
                books_to_note = []
                c.descendants.map(&:id).each do |cat_id|
                    puts "dec cat id #{cat_id}"
                    if Listing.find_by category_id: cat_id
                        book_ids = Listing.where(category_id: cat_id).map(&:book_id)
                        books_to_note.push(*book_ids)
                        puts "book ids #{book_ids}"
                        puts "code #{cat_id}"
                        puts " code id #{cat_id}"
                    end
                end
                books_to_note.uniq! # in case books listed twice in the descendants
                puts " books to note #{books_to_note}"
                books_to_note.each do |book_id|
                    bn = BookNotification.new()
                    book = Book.find(book_id)
                    puts "book #{book.title}"
                    bn.book = book.title
                    within_scope = c.descendants.map(&:id)
                    cat_ids = Listing.where(book_id: book_id).map(&:category_id)
                    cat_ids.uniq! # just in case
                    cat_ids_in_scope = cat_ids & within_scope
                    cat_paths = []
                    cat_ids_in_scope.each do |id|
                        path = []
                        cat = Category.find(id)
                        puts "category for path #{cat.title}"
                        ancestors = cat.ancestors
                        ancestors.reverse!
                        if ancestors.length != 0 or ancestors.length != 1
                            subscriber_interests = ancestors.drop(lineage)
                            subscriber_interests.map(&:title).each do |cat_segment|
                                path.push(cat_segment) 
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
        n.notifications = bn_objs
        n.save
        end
    end
end
