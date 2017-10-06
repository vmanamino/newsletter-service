class Category < ActiveRecord::Base
    acts_as_tree order: "title"
    validates :code, :title, presence: true
    validates :code, uniqueness: true
end
