class AddCategoryCodesToBooks < ActiveRecord::Migration
  def change
    add_column :books, :categoryCodes, :string
  end
end
