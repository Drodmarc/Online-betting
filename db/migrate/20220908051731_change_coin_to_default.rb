class ChangeCoinToDefault < ActiveRecord::Migration[6.1]
  def change
    change_column :orders, :coin, :integer,  default: 0
  end
end
