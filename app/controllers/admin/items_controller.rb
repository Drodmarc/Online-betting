class Admin::ItemsController < AdminController
  before_action :set_item, only: [:edit, :update, :destroy]
  def index
    @items = Item.includes(:category)
    if params['item'].present?
      @items = @items.where(name: params['item'])
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "Successfully Created"
      redirect_to admin_items_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      flash[:notice] = "Successfully Updated"
      redirect_to admin_items_path
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      flash[:notice] = "Successfully deleted"
      redirect_to admin_items_path
    end
  end

  private
  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bets, :state, :batch_at, :online_at, :offline_at, :start_at, :status, :category_id)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
