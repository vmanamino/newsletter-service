class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :recipient
      t.references :subscriber, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
