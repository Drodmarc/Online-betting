class AddBetToWinners < ActiveRecord::Migration[6.1]
  def change
    add_reference :winners, :bet, index: true
  end
end
