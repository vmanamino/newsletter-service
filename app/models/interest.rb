class Interest < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :category
end
