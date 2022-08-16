class Admin::ItemsController < ApplicationController
  before_action :set_item, only: [:edit, :update, :destroy]
  def index
    @items = Item.all
    unless params['search'].blank?
      @items = @items.where(name: params['search'])
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_items_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      redirect_to admin_items_path
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to admin_items_path
    end
  end

  private
  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bets, :state, :batch_at, :online_at, :offline_at, :start_at, :status)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
