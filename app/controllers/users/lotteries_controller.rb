class Users::LotteriesController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :set_item, only: [:create]

  def index
    @items = Item.active.starting
    @items = @items.includes(:category).where(category: { name: params[:category] }) if params[:category].present?
    @categories = Category.all
  end

  def show
    if @item = Item.active.starting.find_by_id(params[:id])
      @user_bets = @item.bets.where(user: current_user).where(batch_count: @item.batch_count)
      @bet = Bet.new
    else
      render_404
    end
  end

  def create
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
      flash[:notice] = "successfully created"
    rescue ActiveRecord::RecordInvalid => exception
      flash[:alert] = exception
    end
    redirect_to users_lottery_path(@bet.item)
  end

  private

  def set_item
    @item = Item.find(params[:bet][:item_id])
  end

  def bet_params
    params.require(:bet).permit(:coins, :item_id)
  end
end
