class ChangeColumnDefaultInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :coins, :integer,  default: 0
    change_column :users, :children_members, :integer,  default: 0
    change_column :users, :total_used_coins, :integer,  default: 0
    change_column :users, :member_total_deposits, :decimal, default: 0
    change_column :users, :total_deposit, :decimal, default: 0
  end
end
