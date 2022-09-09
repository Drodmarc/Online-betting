class ChangeAmountToDefault < ActiveRecord::Migration[6.1]
  def change
    change_column :orders, :amount, :decimal,  default: 0
  end
end
