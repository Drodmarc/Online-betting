class Users::OffersController < ApplicationController
  before_action :set_order, only: :order
  before_action :authenticate_user!, only: :order

  def index
    @offers = Offer.active
  end

  def order
    @order = Order.new()
    @order.genre = :deposit
    @order.amount = @offer.amount
    @order.coin = @offer.coin
    @order.user = current_user
    @order.offer = @offer

    if @order.save
      flash[:notice] = "Ordered successfully"
      redirect_to users_offers_path
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
      render :index
    end
  end

  def set_order
    @offer = Offer.active.find(params[:offer_id])
  end
end