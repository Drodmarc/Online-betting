class AddDeletedAtToNewsTickers < ActiveRecord::Migration[6.1]
  def change
    add_column :news_tickers, :deleted_at, :datetime
  end
end
