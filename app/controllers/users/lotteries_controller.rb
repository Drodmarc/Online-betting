class Users::LotteriesController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :set_item, only: :create

  def index
    @items = Item.active.starting
    @items = @items.includes(:category).where(category: { name: params[:category] }) if params[:category].present?
    @categories = Category.all
  end

  def show
    @item = Item.active.starting.find(params[:id])
    @user_bets = @item.bets.where(user: current_user).where(batch_count: @item.batch_count).betting
    @bet = Bet.new
  end

  def create
    if current_user.coins >= params[:bet][:coins].to_i
      begin
        loop_count = params[:bet][:coins].to_i
        params[:bet][:coins] = 1
        params[:bet][:item_id] = @item
        ActiveRecord::Base.transaction do
          loop_count.times do
            @bet = Bet.new(bet_params)
            @bet.item = @item
            @bet.user = current_user
            @bet.batch_count = @item.batch_count
            @bet.save!
          end
        end
        flash[:notice] = "Bet successfully "
      rescue ActiveRecord::RecordInvalid => exception
        flash[:alert] = exception
      end
      redirect_to users_lottery_path(@item)
      else
        flash[:alert] = "Your coins is #{current_user.coins}, it is insufficient for your bet. Buy coins and bet again!"
      redirect_to users_lottery_path(@item)
    end
  end

  private

  def set_item
    @item = Item.find(params[:bet][:item_id])
  end

  def bet_params
    params.require(:bet).permit(:coins, :item_id)
  end
end