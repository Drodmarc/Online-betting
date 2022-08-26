class CreateWinners < ActiveRecord::Migration[6.1]
  def change
    create_table :winners do |t|
      t.integer :item_batch_count
      t.string :state
      t.integer :price
      t.datetime :paid_at
      t.string :picture
      t.string :comment
      t.belongs_to :item
      t.belongs_to :user
      t.belongs_to :address
      t.belongs_to :admin
      t.timestamps
    end
  end
end
