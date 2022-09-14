class HomeController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @winners = Winner.published.limit(4).order(id: :desc)
    @items = Item.active.starting.limit(9).order(id: :desc)
  end
end