class BookNotification < ActiveRecord::Base
    belongs_to :newsletter
    serialize :categoryPaths, Array
end
