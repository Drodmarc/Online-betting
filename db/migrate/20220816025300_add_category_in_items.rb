class AddCategoryInItems < ActiveRecord::Migration[6.1]
  def change
    add_reference :items, :category, index: true
  end
end
