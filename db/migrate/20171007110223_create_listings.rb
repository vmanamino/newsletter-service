class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :book_id, index: true
      t.integer :category_id, index: true

      t.timestamps null: false
    end
  end
end
