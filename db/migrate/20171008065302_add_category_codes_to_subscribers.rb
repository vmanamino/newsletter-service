class AddCategoryCodesToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :categoryCodes, :string
  end
end
