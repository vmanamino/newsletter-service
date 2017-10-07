class Newsletter < ActiveRecord::Base
  belongs_to :subscriber
  
  after_initialize :default, if: :new_record?
  
  def default
    self.recipient = self.subscriber.email 
  end
  
end
