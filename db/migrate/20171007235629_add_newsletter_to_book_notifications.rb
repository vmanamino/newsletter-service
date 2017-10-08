class AddNewsletterToBookNotifications < ActiveRecord::Migration
  def change
    add_reference :book_notifications, :newsletter, index: true, foreign_key: true
  end
end
