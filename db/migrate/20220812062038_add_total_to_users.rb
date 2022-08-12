class AddTotalToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :total_used_coins, :integer
    add_column :users, :member_total_deposits, :decimal
  end
end
