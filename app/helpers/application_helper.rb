module ApplicationHelper
  def concat_address(address)
    return if address.nil?
    "#{address.street_address}, #{address.barangay.name}, #{address.city.name}, #{address.province.name}, #{address.region.name}"
  end

  def banners
    Banner.where('online_at <= ? AND offline_at > ?', Time.now, Time.now).active
  end

  def news_tickers
    NewsTicker.active.limit(5)
  end
end