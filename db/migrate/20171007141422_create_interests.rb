class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :subscriber_id, index: true
      t.integer :category_id, index: true

      t.timestamps null: false
    end
  end
end
