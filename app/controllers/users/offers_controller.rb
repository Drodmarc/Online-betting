class Users::OffersController < ApplicationController
  before_action :set_order, only: :order
  before_action :authenticate_user!, only: :order

  def index
    @offers = Offer.active
  end

  def order
    @order = Order.new
    @order.genre = :deposit
    @order.amount = @offer.amount
    @order.coin = @offer.coin
    @order.user = current_user
    @order.offer = @offer
    if @order.save
      if @order.may_submit? && @order.submit!
        flash[:notice] = "Ordered successfully"
      else
        flash[:alert] = "Ordered failed"
        @order.cancel!
      end
      redirect_to users_offers_path
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
      render :index
    end
  end

  private

  def set_order
    @offer = Offer.active.find(params[:offer_id])
  end
end