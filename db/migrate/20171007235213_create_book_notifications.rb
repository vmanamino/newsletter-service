class CreateBookNotifications < ActiveRecord::Migration
  def change
    create_table :book_notifications do |t|
      t.string :book
      t.string :catagoryPaths

      t.timestamps null: false
    end
  end
end
