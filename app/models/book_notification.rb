class BookNotification < ActiveRecord::Base
    belongs_to :newsletter
    serialize :catagoryPaths
end
