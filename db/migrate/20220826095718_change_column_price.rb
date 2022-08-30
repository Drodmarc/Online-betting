class ChangeColumnPrice < ActiveRecord::Migration[6.1]
  def change
    change_column :winners, :price, :decimal
  end
end
