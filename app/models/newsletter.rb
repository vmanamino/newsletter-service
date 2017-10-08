class Newsletter < ActiveRecord::Base
  belongs_to :subscriber
  has_many :book_notifications
  serialize :notifications
  after_initialize :default, if: :new_record?
  
  def default
    self.recipient = self.subscriber.email 
  end
  
end
