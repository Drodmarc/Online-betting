class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :serial_number
      t.string :state
      t.integer :genre
      t.string :remarks
      t.integer :coin
      t.decimal :amount
      t.belongs_to :user
      t.belongs_to :offer
      t.timestamps
    end
  end
end
