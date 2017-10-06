class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :code
      t.string :title
      t.string :superCategoryCode
      
      t.timestamps null: false
    end
  end
end
