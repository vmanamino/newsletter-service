class AddNotificationsToNewsletter < ActiveRecord::Migration
  def change
    add_column :newsletters, :notifications, :string
  end
end
