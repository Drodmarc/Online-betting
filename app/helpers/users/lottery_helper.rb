module Users::LotteryHelper
  def progress(item)
    batch = item.bets.where(batch_count: item.batch_count).betting.count
    minimum_bets = item.minimum_bets
    [(batch/minimum_bets) * 100, 100].min.to_i
  end
end